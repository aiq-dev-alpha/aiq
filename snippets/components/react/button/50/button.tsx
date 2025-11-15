import React from 'react';

export interface ComponentProps {
  label?: string;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  theme?: { primary?: string };
  className?: string;
  disabled?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Button',
  onClick,
  variant = 'primary',
  size = 'medium',
  theme = {},
  className = '',
  disabled = false
}) => {
  const primary = theme.primary || '#f59e0b';
  
  const variants = {
    primary: { bg: primary, color: '#fff', border: 'none' },
    secondary: { bg: '#6b7280', color: '#fff', border: 'none' },
    outline: { bg: 'transparent', color: primary, border: `2px solid ${primary}` }
  };
  
  const sizes = {
    small: { padding: '16px 23px', fontSize: '15px' },
    medium: { padding: '16px 23px', fontSize: '15px' },
    large: { padding: '16px 23px', fontSize: '15px' }
  };
  
  const variantStyle = variants[variant];
  const sizeStyle = sizes[size];
  
  return (
    <button
      className={className}
      onClick={onClick}
      disabled={disabled}
      style={{
        ...variantStyle,
        ...sizeStyle,
        borderRadius: '25px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        fontWeight: '400',
        opacity: disabled ? 0.5 : 1,
        transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
        boxShadow: '0 7px 17px rgba(0,0,0,0.18)'
      }}
      onMouseEnter={(e) => !disabled && (e.currentTarget.style.transform = 'translateY(-2px)')}
      onMouseLeave={(e) => !disabled && (e.currentTarget.style.transform = 'translateY(0)')}
    >
      {label}
    </button>
  );
};