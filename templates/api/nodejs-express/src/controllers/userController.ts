import { Request, Response } from 'express';
import { asyncHandler } from '../middleware/error';
import { AppError } from '../middleware/error';
import User from '../models/User';
import logger from '../config/logger';
import { HttpStatusCode, ApiResponse, PaginatedResponse, QueryOptions } from '../types';

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Get all users (Admin only)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/PageParam'
 *       - $ref: '#/components/parameters/LimitParam'
 *       - $ref: '#/components/parameters/SortParam'
 *       - $ref: '#/components/parameters/SearchParam'
 *       - name: role
 *         in: query
 *         description: Filter by user role
 *         schema:
 *           type: string
 *           enum: [user, admin, moderator]
 *       - name: isActive
 *         in: query
 *         description: Filter by user status
 *         schema:
 *           type: boolean
 *     responses:
 *       200:
 *         description: Users retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PaginatedResponse'
 *       401:
 *         $ref: '#/components/responses/401'
 *       403:
 *         $ref: '#/components/responses/403'
 */
export const getUsers = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const {
    page = 1,
    limit = 10,
    sort = '-createdAt',
    search,
    role,
    isActive
  } = req.query as QueryOptions & { role?: string; isActive?: string };

  // Build query
  const query: any = {};

  if (search) {
    query.$or = [
      { firstName: { $regex: search, $options: 'i' } },
      { lastName: { $regex: search, $options: 'i' } },
      { email: { $regex: search, $options: 'i' } }
    ];
  }

  if (role) {
    query.role = role;
  }

  if (isActive !== undefined) {
    query.isActive = isActive === 'true';
  }

  // Execute query with pagination
  const skip = (Number(page) - 1) * Number(limit);
  const users = await User.find(query)
    .sort(sort as string)
    .skip(skip)
    .limit(Number(limit))
    .select('-__v');

  // Get total count for pagination
  const total = await User.countDocuments(query);

  const response: PaginatedResponse = {
    success: true,
    message: 'Users retrieved successfully',
    data: {
      items: users,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / Number(limit))
      }
    }
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /users/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/IdParam'
 *     responses:
 *       200:
 *         description: User retrieved successfully
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
 *                   example: User retrieved successfully
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       401:
 *         $ref: '#/components/responses/401'
 *       404:
 *         $ref: '#/components/responses/404'
 */
export const getUserById = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;

  const user = await User.findById(id).select('-__v');
  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  const response: ApiResponse = {
    success: true,
    message: 'User retrieved successfully',
    data: user
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /users:
 *   post:
 *     summary: Create new user (Admin only)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserRegistration'
 *     responses:
 *       201:
 *         description: User created successfully
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
 *                   example: User created successfully
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         $ref: '#/components/responses/400'
 *       401:
 *         $ref: '#/components/responses/401'
 *       403:
 *         $ref: '#/components/responses/403'
 *       409:
 *         description: User already exists
 */
export const createUser = asyncHandler(async (req: Request, res: Response): Promise<void> => {
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

  logger.info(`New user created by admin: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User created successfully',
    data: user
  };

  res.status(HttpStatusCode.CREATED).json(response);
});

/**
 * @swagger
 * /users/{id}:
 *   put:
 *     summary: Update user by ID
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/IdParam'
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
 *               role:
 *                 type: string
 *                 enum: [user, admin, moderator]
 *               isActive:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: User updated successfully
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
 *                   example: User updated successfully
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         $ref: '#/components/responses/400'
 *       401:
 *         $ref: '#/components/responses/401'
 *       404:
 *         $ref: '#/components/responses/404'
 */
export const updateUser = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;
  const { firstName, lastName, email, role, isActive } = req.body;

  // Check if email is already taken by another user
  if (email) {
    const existingUser = await User.findOne({ email, _id: { $ne: id } });
    if (existingUser) {
      throw new AppError('Email already in use', HttpStatusCode.CONFLICT);
    }
  }

  // Update user
  const user = await User.findByIdAndUpdate(
    id,
    {
      ...(firstName && { firstName }),
      ...(lastName && { lastName }),
      ...(email && { email, isEmailVerified: false }),
      ...(role && { role }),
      ...(isActive !== undefined && { isActive })
    },
    {
      new: true,
      runValidators: true
    }
  ).select('-__v');

  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  logger.info(`User updated: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User updated successfully',
    data: user
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /users/{id}:
 *   delete:
 *     summary: Delete user by ID (Admin only)
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/IdParam'
 *     responses:
 *       200:
 *         $ref: '#/components/responses/200'
 *       401:
 *         $ref: '#/components/responses/401'
 *       403:
 *         $ref: '#/components/responses/403'
 *       404:
 *         $ref: '#/components/responses/404'
 */
export const deleteUser = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;

  const user = await User.findByIdAndDelete(id);
  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  logger.info(`User deleted: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User deleted successfully'
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /users/{id}/deactivate:
 *   patch:
 *     summary: Deactivate user account
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/IdParam'
 *     responses:
 *       200:
 *         $ref: '#/components/responses/200'
 *       401:
 *         $ref: '#/components/responses/401'
 *       404:
 *         $ref: '#/components/responses/404'
 */
export const deactivateUser = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;

  const user = await User.findByIdAndUpdate(
    id,
    { isActive: false },
    { new: true }
  );

  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  logger.info(`User deactivated: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User deactivated successfully'
  };

  res.status(HttpStatusCode.OK).json(response);
});

/**
 * @swagger
 * /users/{id}/activate:
 *   patch:
 *     summary: Activate user account
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *       - cookieAuth: []
 *     parameters:
 *       - $ref: '#/components/parameters/IdParam'
 *     responses:
 *       200:
 *         $ref: '#/components/responses/200'
 *       401:
 *         $ref: '#/components/responses/401'
 *       404:
 *         $ref: '#/components/responses/404'
 */
export const activateUser = asyncHandler(async (req: Request, res: Response): Promise<void> => {
  const { id } = req.params;

  const user = await User.findByIdAndUpdate(
    id,
    { isActive: true },
    { new: true }
  );

  if (!user) {
    throw new AppError('User not found', HttpStatusCode.NOT_FOUND);
  }

  logger.info(`User activated: ${user.email}`);

  const response: ApiResponse = {
    success: true,
    message: 'User activated successfully'
  };

  res.status(HttpStatusCode.OK).json(response);
});