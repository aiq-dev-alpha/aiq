import Joi from 'joi';
import { Request, Response, NextFunction } from 'express';
import { formatValidationError } from '../middleware/error';
import { HttpStatusCode } from '../types';

// Common validation patterns
export const commonValidation = {
  objectId: Joi.string().regex(/^[0-9a-fA-F]{24}$/).message('Invalid ID format'),
  email: Joi.string().email().lowercase().trim(),
  password: Joi.string().min(8).pattern(new RegExp('^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]')),
  name: Joi.string().min(2).max(50).trim(),
  phone: Joi.string().pattern(/^[+]?[\d\s-()]+$/),
  url: Joi.string().uri(),
  pagination: {
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(10),
    sort: Joi.string(),
    fields: Joi.string(),
    search: Joi.string().trim()
  }
};

// User validation schemas
export const userValidation = {
  register: Joi.object({
    email: commonValidation.email.required().messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    }),
    password: commonValidation.password.required().messages({
      'string.min': 'Password must be at least 8 characters long',
      'string.pattern.base': 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
      'any.required': 'Password is required'
    }),
    firstName: commonValidation.name.required().messages({
      'string.min': 'First name must be at least 2 characters long',
      'string.max': 'First name cannot exceed 50 characters',
      'any.required': 'First name is required'
    }),
    lastName: commonValidation.name.required().messages({
      'string.min': 'Last name must be at least 2 characters long',
      'string.max': 'Last name cannot exceed 50 characters',
      'any.required': 'Last name is required'
    }),
    role: Joi.string().valid('user', 'admin', 'moderator').default('user')
  }),

  login: Joi.object({
    email: commonValidation.email.required().messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    }),
    password: Joi.string().required().messages({
      'any.required': 'Password is required'
    })
  }),

  updateProfile: Joi.object({
    firstName: commonValidation.name,
    lastName: commonValidation.name,
    email: commonValidation.email
  }),

  changePassword: Joi.object({
    currentPassword: Joi.string().required().messages({
      'any.required': 'Current password is required'
    }),
    newPassword: commonValidation.password.required().messages({
      'string.min': 'New password must be at least 8 characters long',
      'string.pattern.base': 'New password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
      'any.required': 'New password is required'
    })
  }),

  resetPassword: Joi.object({
    email: commonValidation.email.required().messages({
      'string.email': 'Please provide a valid email address',
      'any.required': 'Email is required'
    })
  }),

  confirmResetPassword: Joi.object({
    token: Joi.string().required().messages({
      'any.required': 'Reset token is required'
    }),
    password: commonValidation.password.required().messages({
      'string.min': 'Password must be at least 8 characters long',
      'string.pattern.base': 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
      'any.required': 'Password is required'
    })
  })
};

// Query validation schema
export const queryValidation = Joi.object({
  ...commonValidation.pagination
});

// Generic validation middleware
export const validate = (schema: Joi.ObjectSchema, property: 'body' | 'query' | 'params' = 'body') => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const { error } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true
    });

    if (error) {
      const formattedError = formatValidationError(error.details);
      res.status(HttpStatusCode.BAD_REQUEST).json(formattedError);
      return;
    }

    next();
  };
};

// Combined validation for multiple properties
export const validateMultiple = (validations: {
  body?: Joi.ObjectSchema;
  query?: Joi.ObjectSchema;
  params?: Joi.ObjectSchema;
}) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const errors: any[] = [];

    // Validate body
    if (validations.body) {
      const { error } = validations.body.validate(req.body, {
        abortEarly: false,
        stripUnknown: true
      });
      if (error) {
        errors.push(...error.details.map(detail => ({ ...detail, source: 'body' })));
      }
    }

    // Validate query
    if (validations.query) {
      const { error } = validations.query.validate(req.query, {
        abortEarly: false,
        stripUnknown: true
      });
      if (error) {
        errors.push(...error.details.map(detail => ({ ...detail, source: 'query' })));
      }
    }

    // Validate params
    if (validations.params) {
      const { error } = validations.params.validate(req.params, {
        abortEarly: false,
        stripUnknown: true
      });
      if (error) {
        errors.push(...error.details.map(detail => ({ ...detail, source: 'params' })));
      }
    }

    if (errors.length > 0) {
      const formattedError = formatValidationError(errors);
      res.status(HttpStatusCode.BAD_REQUEST).json(formattedError);
      return;
    }

    next();
  };
};

// Sanitize input to prevent XSS
export const sanitizeInput = (req: Request, res: Response, next: NextFunction): void => {
  // This is a basic implementation - you might want to use a dedicated library like xss
  const sanitize = (obj: any): any => {
    if (typeof obj === 'string') {
      return obj.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
    }
    if (typeof obj === 'object' && obj !== null) {
      for (const key in obj) {
        obj[key] = sanitize(obj[key]);
      }
    }
    return obj;
  };

  req.body = sanitize(req.body);
  req.query = sanitize(req.query);
  req.params = sanitize(req.params);

  next();
};