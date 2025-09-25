import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import mongoSanitize from 'express-mongo-sanitize';
import cookieParser from 'cookie-parser';
import path from 'path';

// Import configurations
import { setupSwagger } from './config/swagger';
import logger from './config/logger';

// Import middleware
import { errorHandler, notFoundHandler, timeoutHandler } from './middleware/error';
import {
  corsOptions,
  helmetOptions,
  compressionOptions,
  mongoSanitizeOptions,
  cookieOptions,
  securityHeaders,
  requestLogger,
  requestSizeLimiter,
  rateLimiters
} from './middleware/security';
import { sanitizeInput } from './utils/validation';

// Import routes
import routes from './routes';

const createApp = (): Application => {
  const app = express();

  // Trust proxy (important for rate limiting and getting real IP addresses)
  app.set('trust proxy', 1);

  // Request timeout middleware
  app.use(timeoutHandler(30000)); // 30 seconds

  // Security middleware
  app.use(helmet(helmetOptions));
  app.use(securityHeaders);

  // CORS middleware
  app.use(cors(corsOptions));

  // Compression middleware
  app.use(compression(compressionOptions));

  // Body parsing middleware
  app.use(express.json({
    limit: process.env.REQUEST_SIZE_LIMIT || '10mb'
  }));
  app.use(express.urlencoded({
    extended: true,
    limit: process.env.REQUEST_SIZE_LIMIT || '10mb'
  }));

  // Cookie parser middleware
  app.use(cookieParser(cookieOptions.secret, cookieOptions));

  // Request size limiter
  app.use(requestSizeLimiter('10mb'));

  // MongoDB injection prevention
  app.use(mongoSanitize(mongoSanitizeOptions));

  // Input sanitization
  app.use(sanitizeInput);

  // Request logging middleware
  if (process.env.NODE_ENV !== 'test') {
    app.use(requestLogger);
  }

  // Rate limiting (apply to all routes except health checks)
  app.use('/api', rateLimiters.general);

  // Serve static files
  app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

  // API routes
  const apiVersion = process.env.API_VERSION || 'v1';
  const apiPrefix = process.env.API_PREFIX || '/api';
  app.use(`${apiPrefix}/${apiVersion}`, routes);

  // Health check route (without API prefix for load balancers)
  app.use('/health', routes);

  // Setup Swagger documentation
  if (process.env.NODE_ENV !== 'production') {
    setupSwagger(app);
  }

  // Root route
  app.get('/', (req, res) => {
    res.json({
      success: true,
      message: 'Welcome to {{PROJECT_NAME}} API',
      data: {
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'development',
        apiVersion,
        documentation: process.env.NODE_ENV !== 'production' ? '/api-docs' : 'Not available in production',
        endpoints: {
          api: `${apiPrefix}/${apiVersion}`,
          health: '/health',
          docs: process.env.NODE_ENV !== 'production' ? '/api-docs' : null
        }
      }
    });
  });

  // 404 handler for undefined routes
  app.use('*', notFoundHandler);

  // Global error handling middleware (must be last)
  app.use(errorHandler);

  return app;
};

export default createApp;