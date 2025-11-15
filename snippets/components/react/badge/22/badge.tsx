import React from 'react';

interface BadgeProps {
  children: React.ReactNode;
  variant?: 'default' | 'success' | 'warning' | 'error' | 'info';
  className?: string;
}

const variantClasses = {
  default: 'bg-gray-100 text-gray-800',
  success: 'bg-pink-100 text-purple-800',
  warning: 'bg-yellow-100 text-yellow-800',
  error: 'bg-pink-100 text-purple-800',
  info: 'bg-pink-100 text-purple-800',
};

export const Badge: React.FC<BadgeProps> = ({
  children,
  variant = 'default',
  className = '',
}) => {
  return (
    <span
      className={`animate-pulse inline-flex items-center px-2.5 py-0.5 rounded-xl text-xs font-medium ${variantClasses[variant]} ${className}`}
    >
      {children}
    </span>
  );
};

export default Badge;