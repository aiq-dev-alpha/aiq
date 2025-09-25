import { Request, Response, NextFunction } from 'express';
import logger from '../config/logger';
import { HttpStatusCode, ApiResponse } from '../types';

export class AppError extends Error {
  public statusCode: number;
  public isOperational: boolean;

  constructor(message: string, statusCode: number = HttpStatusCode.INTERNAL_SERVER_ERROR) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

/**
 * Global error handling middleware
 */
export const errorHandler = (
  error: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  let err = error as AppError;

  // Log error
  logger.error(`Error ${err.statusCode || 500} - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip}`);

  // Mongoose bad ObjectId
  if (error.name === 'CastError') {
    const message = 'Resource not found';
    err = new AppError(message, HttpStatusCode.NOT_FOUND);
  }

  // Mongoose duplicate key
  if ((error as any).code === 11000) {
    const message = 'Duplicate field value entered';
    err = new AppError(message, HttpStatusCode.CONFLICT);
  }

  // Mongoose validation error
  if (error.name === 'ValidationError') {
    const message = Object.values((error as any).errors).map((val: any) => val.message);
    err = new AppError(message.join(', '), HttpStatusCode.BAD_REQUEST);
  }

  // JWT errors
  if (error.name === 'JsonWebTokenError') {
    const message = 'Invalid token';
    err = new AppError(message, HttpStatusCode.UNAUTHORIZED);
  }

  if (error.name === 'TokenExpiredError') {
    const message = 'Token expired';
    err = new AppError(message, HttpStatusCode.UNAUTHORIZED);
  }

  const response: ApiResponse = {
    success: false,
    message: err.message || 'Internal server error'
  };

  // Include stack trace in development
  if (process.env.NODE_ENV === 'development') {
    response.error = err.stack;
  }

  res.status(err.statusCode || HttpStatusCode.INTERNAL_SERVER_ERROR).json(response);
};

/**
 * Async error wrapper
 */
export const asyncHandler = (fn: Function) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

/**
 * 404 handler for undefined routes
 */
export const notFoundHandler = (req: Request, res: Response, next: NextFunction): void => {
  const error = new AppError(`Not found - ${req.originalUrl}`, HttpStatusCode.NOT_FOUND);
  next(error);
};

/**
 * Request timeout middleware
 */
export const timeoutHandler = (timeout: number = 30000) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const timer = setTimeout(() => {
      if (!res.headersSent) {
        res.status(HttpStatusCode.SERVICE_UNAVAILABLE).json({
          success: false,
          message: 'Request timeout'
        });
      }
    }, timeout);

    res.on('finish', () => {
      clearTimeout(timer);
    });

    next();
  };
};

/**
 * Validation error formatter
 */
export const formatValidationError = (errors: any[]): ApiResponse => {
  return {
    success: false,
    message: 'Validation failed',
    errors: errors.map(error => ({
      field: error.path || error.field,
      message: error.message || error.msg
    }))
  };
};