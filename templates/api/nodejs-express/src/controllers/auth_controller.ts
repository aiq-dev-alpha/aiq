import { Request, Response } from 'express';
import { asyncHandler } from '../middleware/error';
import { AppError } from '../middleware/error';
import User from '../models/User';
import { JWTUtil } from '../utils/jwt';
import logger from '../config/logger';
import { HttpStatusCode, ApiResponse, JwtPayload } from '../types';

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Register a new user
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserRegistration'
 *     responses:
 *       201:
 *         description: User registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/AuthResponse'
 *       400:
 *         $ref: '#/components/responses/400'
 *       409:
 *         description: User already exists
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
export const register = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { email, password, firstName, lastName, role } = req.body;

  // Check if user already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw new AppError('User already exists with this email', HttpStatusCode.CONFLICT);
  }

  // Create new user
  const user = await User.create({
    email,
    password,
    firstName,
    lastName,
    role
  });

  // Generate JWT token
  const payload: JwtPayload = {
    id: user._id,
    email: user.email,
    role: user.role
  };

  const token = JWTUtil.generateToken(payload);

  // Set cookie
  const cookieExpire = parseInt(process.env.JWT_COOKIE_EXPIRE || '7');
  res.cookie('token', token, {
    expires: new Date(Date.now() + cookieExpire * 24 * 60 * 60 * 1000),
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  });

  logger.info(`New user registered: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User registered successfully',
    data: {
      token,
      user
    }
  };

  res.status(HttpStatusCode.CREATED).json(response);
});

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Login user
 *     tags: [Authentication]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserLogin'
 *     responses:
 *       200:
 *         description: Login successful
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/AuthResponse'
 *       400:
 *         $ref: '#/components/responses/400'
 *       401:
 *         $ref: '#/components/responses/401'
 */
export const login = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { email, password } = req.body;

  // Find user and include password field
  const user = await User.findOne({ email, isActive: true }).select('+password');
  if (!user) {
    throw new AppError('Invalid credentials', HttpStatusCode.UNAUTHORIZED);
  }

  // Check password
  const isPasswordValid = await user.comparePassword(password);
  if (!isPasswordValid) {
    throw new AppError('Invalid credentials', HttpStatusCode.UNAUTHORIZED);
  }

  // Update last login
  user.lastLogin = new Date();
  await user.save({ validateBeforeSave: false });

  // Generate JWT token
  const payload: JwtPayload = {
    id: user._id,
    email: user.email,
    role: user.role
  };

  const token = JWTUtil.generateToken(payload);

  // Set cookie
  const cookieExpire = parseInt(process.env.JWT_COOKIE_EXPIRE || '7');
  res.cookie('token', token, {
    expires: new Date(Date.now() + cookieExpire * 24 * 60 * 60 * 1000),
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  });

  // Remove password from response
  user.password = undefined as any;

  logger.info(`User logged in: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'Login successful',
    data: {
      token,
      user
    }
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Logout user
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     responses:
 *       200:
 *         $ref: '#/components/responses/200'
 *       401:
 *         $ref: '#/components/responses/401'
 */
export const logout = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  // Clear cookie
  res.clearCookie('token');

  logger.info(`User logged out: ${req.user?.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'Logout successful'
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /auth/profile:
 *   get:
 *     summary: Get current user profile
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     responses:
 *       200:
 *         description: Profile retrieved successfully
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
 *                   example: Profile retrieved successfully
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       401:
 *         $ref: '#/components/responses/401'
 */
export const getProfile = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const response: ApiResponse = {
    success: true,
    message: 'Profile retrieved successfully',
    data: req.user
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /auth/profile:
 *   put:
 *     summary: Update user profile
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               firstName:
 *                 type: string
 *                 example: John
 *               lastName:
 *                 type: string
 *                 example: Doe
 *               email:
 *                 type: string
 *                 format: email
 *                 example: john.doe@example.com
 *     responses:
 *       200:
 *         description: Profile updated successfully
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
 *                   example: Profile updated successfully
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         $ref: '#/components/responses/400'
 *       401:
 *         $ref: '#/components/responses/401'
 */
export const updateProfile = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { firstName, lastName, email } = req.body;
  const userId = req.user!._id;

  // Check if email is already taken by another user
  if (email) {
    const existingUser = await User.findOne({ email, _id: { $ne: userId } });
    if (existingUser) {
      throw new AppError('Email already in use', HttpStatusCode.CONFLICT);
    }
  }

  // Update user
  const user = await User.findByIdAndUpdate(
    userId,
    {
      ...(firstName && { firstName }),
      ...(lastName && { lastName }),
      ...(email && { email, isEmailVerified: false }) // Reset email verification if email changed
    },
    {
      new: true,
      runValidators: true
    }
  );

  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  logger.info(`User profile updated: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'Profile updated successfully',
    data: user
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /auth/change-password:
 *   put:
 *     summary: Change user password
 *     tags: [Authentication]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [currentPassword, newPassword]
 *             properties:
 *               currentPassword:
 *                 type: string
 *                 example: OldPassword123!
 *               newPassword:
 *                 type: string
 *                 example: NewPassword123!
 *     responses:
 *       200:
 *         $ref: '#/components/responses/200'
 *       400:
 *         $ref: '#/components/responses/400'
 *       401:
 *         $ref: '#/components/responses/401'
 */
export const changePassword = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { currentPassword, newPassword } = req.body;
  const userId = req.user!._id;

  // Get user with password
  const user = await User.findById(userId).select('+password');
  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  // Check current password
  const isCurrentPasswordValid = await user.comparePassword(currentPassword);
  if (!isCurrentPasswordValid) {
    throw new AppError('Current password is incorrect', HttpStatusCode.UNAUTHORIZED);
  }

  // Update password
  user.password = newPassword;
  await user.save();

  logger.info(`Password changed for user: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'Password changed successfully'
  };

  res.status(HttpStatusCode.OK).json(response);
});