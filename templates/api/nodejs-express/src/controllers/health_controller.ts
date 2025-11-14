import { Request, Response } from 'express';
import { asyncHandler } from '../middleware/error';
import mongoose from 'mongoose';
import { HttpStatusCode, ApiResponse } from '../types';

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Health check endpoint
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Service is healthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Service is healthy
 *                 data:
 *                   type: object
 *                   properties:
 *                     status:
 *                       type: string
 *                       example: OK
 *                     timestamp:
 *                       type: string
 *                       format: date-time
 *                     version:
 *                       type: string
 *                       example: 1.0.0
 *                     environment:
 *                       type: string
 *                       example: development
 *                     uptime:
 *                       type: number
 *                       example: 123.45
 *                     database:
 *                       type: object
 *                       properties:
 *                         status:
 *                           type: string
 *                           example: connected
 *                         name:
 *                           type: string
 *                           example: mongodb
 *       503:
 *         description: Service is unhealthy
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
export const healthCheck = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  // Check database connection
  const dbStatus = {
    status: 'disconnected',
    name: 'mongodb'
  };

  try {
    if (mongoose.connection.readyState === 1) {
      dbStatus.status = 'connected';
    }
  } catch (error) {
    dbStatus.status = 'error';
  }

  // Determine overall health status
  const isHealthy = dbStatus.status === 'connected';

  const healthData = {
    status: isHealthy ? 'OK' : 'ERROR',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    uptime: process.uptime(),
    database: dbStatus,
    memory: {
      used: Math.round((process.memoryUsage().heapUsed / 1024 / 1024) * 100) / 100,
      total: Math.round((process.memoryUsage().heapTotal / 1024 / 1024) * 100) / 100,
      external: Math.round((process.memoryUsage().external / 1024 / 1024) * 100) / 100
    }
  };

  const response: ApiResponse = {
    success: isHealthy,
    message: isHealthy ? 'Service is healthy' : 'Service is unhealthy',
    data: healthData
  };

  const statusCode = isHealthy ? HttpStatusCode.OK : HttpStatusCode.SERVICE_UNAVAILABLE;
  res.status(statusCode).json(response);
});

/**
 * @swagger
 * /health/ready:
 *   get:
 *     summary: Readiness check endpoint
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Service is ready
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Service is ready
 *       503:
 *         description: Service is not ready
 */
export const readinessCheck = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  // Check if all critical dependencies are ready
  const checks = {
    database: mongoose.connection.readyState === 1
  };

  const isReady = Object.values(checks).every(check => check === true);

  const response: ApiResponse = {
    success: isReady,
    message: isReady ? 'Service is ready' : 'Service is not ready',
    data: {
      checks,
      timestamp: new Date().toISOString()
    }
  };

  const statusCode = isReady ? HttpStatusCode.OK : HttpStatusCode.SERVICE_UNAVAILABLE;
  res.status(statusCode).json(response);
});

/**
 * @swagger
 * /health/live:
 *   get:
 *     summary: Liveness check endpoint
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Service is alive
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: Service is alive
 */
export const livenessCheck = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  // Simple liveness check - if this endpoint responds, the service is alive
  const response: ApiResponse = {
    success: true,
    message: 'Service is alive',
    data: {
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    }
  };

  res.status(HttpStatusCode.OK).json(response);
});