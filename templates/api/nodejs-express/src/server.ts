import dotenv from 'dotenv';

// Load environment variables first
dotenv.config();

import createApp from './app';
import connectDB from './config/database';
import logger from './config/logger';

// Handle uncaught exceptions
process.on('uncaughtException', (err: Error) => {
  logger.error('Uncaught Exception:', err);
  process.exit(1);
});

const startServer = async (): Promise<void> => {
  try {
    // Connect to database
    await connectDB();

    // Create Express app
    const app = createApp();

    // Get port from environment
    const PORT = process.env.PORT || 3000;
    const HOST = process.env.HOST || 'localhost';

    // Start server
    const server = app.listen(PORT, () => {
      logger.info(`🚀 Server running in ${process.env.NODE_ENV || 'development'} mode`);
      logger.info(`🌐 Server listening on http://${HOST}:${PORT}`);
      logger.info(`📚 API Documentation: http://${HOST}:${PORT}/api-docs`);
      logger.info(`💊 Health Check: http://${HOST}:${PORT}/health`);
    });

    // Handle unhandled promise rejections
    process.on('unhandledRejection', (reason: unknown, promise: Promise<any>) => {
      logger.error('Unhandled Rejection at:', promise, 'reason:', reason);
      server.close(() => {
        process.exit(1);
      });
    });

    // Handle SIGTERM (for graceful shutdown in containers)
    process.on('SIGTERM', () => {
      logger.info('SIGTERM received, shutting down gracefully');
      server.close(() => {
        logger.info('Process terminated');
      });
    });

    // Handle SIGINT (Ctrl+C)
    process.on('SIGINT', () => {
      logger.info('SIGINT received, shutting down gracefully');
      server.close(() => {
        logger.info('Process terminated');
        process.exit(0);
      });
    });

  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
};

// Start the server
startServer();