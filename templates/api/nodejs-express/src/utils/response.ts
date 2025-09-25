import { Response } from 'express';
import { ApiResponse, PaginatedResponse, HttpStatusCode } from '../types';

/**
 * Utility class for standardized API responses
 */
export class ResponseUtil {
  /**
   * Send success response
   */
  static success<T>(
    res: Response,
    data?: T,
    message: string = 'Success',
    statusCode: number = HttpStatusCode.OK
  ): void {
    const response: ApiResponse<T> = {
      success: true,
      message,
      ...(data !== undefined && { data })
    };

    res.status(statusCode).json(response);
  }

  /**
   * Send error response
   */
  static error(
    res: Response,
    message: string = 'Internal server error',
    statusCode: number = HttpStatusCode.INTERNAL_SERVER_ERROR,
    errors?: Array<{ field: string; message: string }>
  ): void {
    const response: ApiResponse = {
      success: false,
      message,
      ...(errors && { errors })
    };

    res.status(statusCode).json(response);
  }

  /**
   * Send paginated response
   */
  static paginated<T>(
    res: Response,
    items: T[],
    page: number,
    limit: number,
    total: number,
    message: string = 'Data retrieved successfully'
  ): void {
    const pages = Math.ceil(total / limit);

    const response: PaginatedResponse<T> = {
      success: true,
      message,
      data: {
        items,
        pagination: {
          page,
          limit,
          total,
          pages
        }
      }
    };

    res.status(HttpStatusCode.OK).json(response);
  }

  /**
   * Send created response
   */
  static created<T>(
    res: Response,
    data?: T,
    message: string = 'Resource created successfully'
  ): void {
    this.success(res, data, message, HttpStatusCode.CREATED);
  }

  /**
   * Send no content response
   */
  static noContent(res: Response): void {
    res.status(HttpStatusCode.NO_CONTENT).send();
  }

  /**
   * Send not found response
   */
  static notFound(res: Response, message: string = 'Resource not found'): void {
    this.error(res, message, HttpStatusCode.NOT_FOUND);
  }

  /**
   * Send bad request response
   */
  static badRequest(
    res: Response,
    message: string = 'Bad request',
    errors?: Array<{ field: string; message: string }>
  ): void {
    this.error(res, message, HttpStatusCode.BAD_REQUEST, errors);
  }

  /**
   * Send unauthorized response
   */
  static unauthorized(res: Response, message: string = 'Unauthorized'): void {
    this.error(res, message, HttpStatusCode.UNAUTHORIZED);
  }

  /**
   * Send forbidden response
   */
  static forbidden(res: Response, message: string = 'Forbidden'): void {
    this.error(res, message, HttpStatusCode.FORBIDDEN);
  }

  /**
   * Send conflict response
   */
  static conflict(res: Response, message: string = 'Conflict'): void {
    this.error(res, message, HttpStatusCode.CONFLICT);
  }

  /**
   * Send too many requests response
   */
  static tooManyRequests(res: Response, message: string = 'Too many requests'): void {
    this.error(res, message, HttpStatusCode.TOO_MANY_REQUESTS);
  }
}