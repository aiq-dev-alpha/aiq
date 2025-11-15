import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'success' | 'warning' | 'error';
  fullWidth?: boolean;
  children: React.ReactNode;
}

const variantClasses = {
  default: 'border-gray-300 text-gray-700 hover:bg-gray-50',
  success: 'border-green-500 text-green-600 hover:bg-green-50',
  warning: 'border-yellow-500 text-yellow-600 hover:bg-yellow-50',
  error: 'border-red-500 text-red-600 hover:bg-red-50',
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'default',
  fullWidth = false,
  children,
  className = '',
  ...props
}) => {
  return (
    <button
      className={`border-2 rounded-lg px-5 py-2.5 font-semibold transition-all focus:outline-none focus:ring-2 focus:ring-offset-2 ${variantClasses[variant]} ${fullWidth ? 'w-full' : ''} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button;