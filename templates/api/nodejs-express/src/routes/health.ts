import { Router } from 'express';
import { healthCheck, readinessCheck, livenessCheck } from '../controllers/healthController';

const router = Router();

/**
 * Health check routes
 */
router.get('/', healthCheck);
router.get('/ready', readinessCheck);
router.get('/live', livenessCheck);

export default router;