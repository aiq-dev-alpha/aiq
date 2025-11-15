import React from 'react';
interface BadgeProps {
  className?: string;
  label: string;
  variant?: 'success' | 'warning' | 'error' | 'info' | 'neutral';
  icon?: React.ReactNode;
  outlined?: boolean;
}
export const Badge: React.FC<BadgeProps> = ({
  label,
  variant = 'neutral',
  icon,
  outlined = false
}) => {
  const solidVariants = {
    success: 'bg-green-100 text-green-800 border-green-200',
    warning: 'bg-yellow-100 text-yellow-800 border-yellow-200',
    error: 'bg-red-100 text-red-800 border-red-200',
    info: 'bg-blue-100 text-blue-800 border-blue-200',
    neutral: 'bg-gray-100 text-gray-800 border-gray-200'
  };
  const outlineVariants = {
    success: 'border-green-500 text-green-700 bg-white',
    warning: 'border-yellow-500 text-yellow-700 bg-white',
    error: 'border-red-500 text-red-700 bg-white',
    info: 'border-blue-500 text-blue-700 bg-white',
    neutral: 'border-gray-500 text-gray-700 bg-white'
  };
  const classes = outlined ? outlineVariants[variant] : solidVariants[variant];
  return (
    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-medium border ${classes}`}>
      {icon}
      {label}
    </span>
  );
};

export default Badge;