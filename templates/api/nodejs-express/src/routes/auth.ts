import { Router } from 'express';
import {
  register,
  login,
  logout,
  getProfile,
  updateProfile,
  changePassword
} from '../controllers/authController';
import { authenticate } from '../middleware/auth';
import { validate } from '../utils/validation';
import { userValidation } from '../utils/validation';
import { rateLimiters } from '../middleware/security';

const router = Router();

/**
 * Authentication routes
 */

// Public routes
router.post('/register', rateLimiters.auth, validate(userValidation.register), register);
router.post('/login', rateLimiters.auth, validate(userValidation.login), login);

// Protected routes
router.use(authenticate); // Apply authentication middleware to all routes below

router.post('/logout', logout);
router.get('/profile', getProfile);
router.put('/profile', validate(userValidation.updateProfile), updateProfile);
router.put('/change-password', validate(userValidation.changePassword), changePassword);

export default router;