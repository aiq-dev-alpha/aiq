import React from 'react';
interface BadgeProps {
  variant?: 'success' | 'warning' | 'error' | 'info';
  pulse?: boolean;
  size?: 'sm' | 'md' | 'lg';
}
export const Badge: React.FC<BadgeProps> = ({
  variant = 'success',
  pulse = false,
  size = 'md'
}) => {
  const colors = {
    success: 'bg-green-500',
    warning: 'bg-yellow-500',
    error: 'bg-red-500',
    info: 'bg-blue-500'
  };
  const sizes = {
    sm: 'w-2 h-2',
    md: 'w-3 h-3',
    lg: 'w-4 h-4'
  };
  return (
    <span className="relative inline-flex">
      <span className={`${sizes[size]} ${colors[variant]} rounded-full`} />
      {pulse && (
        <span className={`absolute inset-0 ${colors[variant]} rounded-full opacity-75 animate-ping`} />
      )}
    </span>
  );
};
