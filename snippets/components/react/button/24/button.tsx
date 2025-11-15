import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  variant?: 'solid' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onClick?: () => void;
  disabled?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Button',
  variant = 'solid',
  size = 'md',
  theme = {},
  className = '',
  onClick,
  disabled = false
}) => {
  const [isHovered, setIsHovered] = useState(false);
  const [isPressed, setIsPressed] = useState(false);

  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  const sizeStyles = {
    sm: { padding: '6px 16px', fontSize: '14px' },
    md: { padding: '10px 24px', fontSize: '16px' },
    lg: { padding: '14px 32px', fontSize: '18px' }
  };

  const variantStyles = {
    solid: {
      backgroundColor: disabled ? '#d1d5db' : primary,
      color: '#ffffff',
      border: 'none'
    },
    outline: {
      backgroundColor: 'transparent',
      color: primary,
      border: `2px solid ${primary}`
    },
    ghost: {
      backgroundColor: isHovered ? `${primary}15` : 'transparent',
      color: primary,
      border: 'none'
    }
  };

  return (
    <button
      className={className}
      onClick={onClick}
      disabled={disabled}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => { setIsHovered(false); setIsPressed(false); }}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      style={{
        ...sizeStyles[size],
        ...variantStyles[variant],
        borderRadius: '8px',
        fontWeight: 600,
        cursor: disabled ? 'not-allowed' : 'pointer',
        opacity: disabled ? 0.6 : 1,
        transform: isPressed && !disabled ? 'scale(0.95)' : isHovered && !disabled ? 'scale(1.02)' : 'scale(1)',
        boxShadow: isHovered && !disabled ? '0 4px 12px rgba(0,0,0,0.15)' : '0 2px 4px rgba(0,0,0,0.1)',
        transition: 'all 150ms cubic-bezier(0.4, 0, 0.2, 1)',
        outline: 'none'
      }}
    >
      {label}
    </button>
  );
};