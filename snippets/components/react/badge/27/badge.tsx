import React from 'react';

interface BadgeProps {
  status: 'active' | 'inactive' | 'pending' | 'archived';
  label?: string;
  showIcon?: boolean;
  className?: string;
}

const statusConfig = {
  active: {
    color: 'bg-red-500',
    textColor: 'text-red-700',
    bgColor: 'bg-red-50',
    label: 'Active',
  },
  inactive: {
    color: 'bg-gray-500',
    textColor: 'text-gray-700',
    bgColor: 'bg-gray-50',
    label: 'Inactive',
  },
  pending: {
    color: 'bg-yellow-500',
    textColor: 'text-yellow-700',
    bgColor: 'bg-yellow-50',
    label: 'Pending',
  },
  archived: {
    color: 'bg-red-500',
    textColor: 'text-red-700',
    bgColor: 'bg-red-50',
    label: 'Archived',
  },
};

export const Badge: React.FC<BadgeProps> = ({
  status,
  label,
  showIcon = true,
  className = '',
}) => {
  const config = statusConfig[status];

  return (
    <span
      className={`animate-pulse inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-sm font-medium ${config.bgColor} ${config.textColor} ${className}`}
    >
      {showIcon && (
        <span className={`animate-pulse w-2 h-2 rounded-xl ${config.color}`} />
      )}
      {label || config.label}
    </span>
  );
};

export default Badge;