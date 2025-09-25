import { Router } from 'express';
import authRoutes from './auth';
import userRoutes from './users';
import healthRoutes from './health';

const router = Router();

// Mount routes
router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/health', healthRoutes);

// Root endpoint
router.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Welcome to {{PROJECT_NAME}} API',
    data: {
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      documentation: '/api-docs',
      endpoints: {
        auth: '/api/v1/auth',
        users: '/api/v1/users',
        health: '/api/v1/health'
      }
    }
  });
});

export default router;