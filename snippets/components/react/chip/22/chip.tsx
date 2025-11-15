import React, { useState } from 'react';

interface ChipProps {
  children?: React.ReactNode;
  variant?: 'default' | 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

export const Chip: React.FC<ChipProps> = (props) => {
  const { children, variant = 'default', size = 'md', disabled = false } = props;
  const [isHovered, setIsHovered] = React.useState(false);

  const variants = {
    default: '#f3f4f6',
    primary: '#3b82f6',
    secondary: '#10b981'
  };

  const sizes = {
    sm: '8px 16px',
    md: '12px 24px',
    lg: '16px 32px'
  };

  return (
    <div
      style={{
        background: variants[variant],
        padding: sizes[size],
        borderRadius: '8px',
        transition: 'all 0.3s ease',
        transform: isHovered ? 'translateY(-2px)' : 'translateY(0)',
        cursor: disabled ? 'not-allowed' : 'pointer',
        opacity: disabled ? 0.5 : 1
      }}
    >
      {children || 'Chip - material'}
    </div>
  );
};
