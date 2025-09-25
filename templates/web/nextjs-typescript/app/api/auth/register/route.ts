import { NextRequest, NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { signUpSchema } from '@/lib/validations';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { name, email, password } = signUpSchema.parse(body);

    // Check if user already exists
    // In a real app, you'd check your database here
    // const existingUser = await prisma.user.findUnique({
    //   where: { email }
    // });

    // Mock check for existing user
    if (email === 'existing@example.com') {
      return NextResponse.json(
        { message: 'User with this email already exists' },
        { status: 400 }
      );
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create user in database
    // In a real app, you'd save to your database here
    // const user = await prisma.user.create({
    //   data: {
    //     name,
    //     email,
    //     password: hashedPassword,
    //   },
    // });

    // Mock user creation
    const user = {
      id: Date.now().toString(),
      name,
      email,
      password: hashedPassword,
    };

    return NextResponse.json(
      {
        message: 'User created successfully',
        user: { id: user.id, name: user.name, email: user.email },
      },
      { status: 201 }
    );
  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}