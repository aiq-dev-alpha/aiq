import { Router } from 'express';
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  deactivateUser,
  activateUser
} from '../controllers/userController';
import { authenticate, authorize } from '../middleware/auth';
import { validate, validateMultiple } from '../utils/validation';
import { userValidation, queryValidation, commonValidation } from '../utils/validation';
import { UserRole } from '../types';
import Joi from 'joi';

const router = Router();

// Apply authentication middleware to all routes
router.use(authenticate);

/**
 * User management routes
 */

// Get all users (Admin only)
router.get(
  '/',
  authorize(UserRole.ADMIN),
  validate(queryValidation, 'query'),
  getUsers
);

// Create new user (Admin only)
router.post(
  '/',
  authorize(UserRole.ADMIN),
  validate(userValidation.register),
  createUser
);

// Get user by ID
router.get(
  '/:id',
  validateMultiple({
    params: Joi.object({
      id: commonValidation.objectId.required()
    })
  }),
  getUserById
);

// Update user by ID (Admin or own profile)
router.put(
  '/:id',
  validateMultiple({
    params: Joi.object({
      id: commonValidation.objectId.required()
    }),
    body: Joi.object({
      firstName: commonValidation.name,
      lastName: commonValidation.name,
      email: commonValidation.email,
      role: Joi.string().valid(...Object.values(UserRole)),
      isActive: Joi.boolean()
    })
  }),
  updateUser
);

// Delete user by ID (Admin only)
router.delete(
  '/:id',
  authorize(UserRole.ADMIN),
  validateMultiple({
    params: Joi.object({
      id: commonValidation.objectId.required()
    })
  }),
  deleteUser
);

// Deactivate user account
router.patch(
  '/:id/deactivate',
  authorize(UserRole.ADMIN),
  validateMultiple({
    params: Joi.object({
      id: commonValidation.objectId.required()
    })
  }),
  deactivateUser
);

// Activate user account
router.patch(
  '/:id/activate',
  authorize(UserRole.ADMIN),
  validateMultiple({
    params: Joi.object({
      id: commonValidation.objectId.required()
    })
  }),
  activateUser
);

export default router;