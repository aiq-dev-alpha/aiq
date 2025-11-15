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
  const primary = theme.primary || '#ef4444';
  
  const variants = {
    primary: { bg: primary, color: '#fff', border: 'none' },
    secondary: { bg: '#6b7280', color: '#fff', border: 'none' },
    outline: { bg: 'transparent', color: primary, border: `2px solid ${primary}` }
  };
  
  const sizes = {
    small: { padding: '28px 36px', fontSize: '22px' },
    medium: { padding: '28px 36px', fontSize: '22px' },
    large: { padding: '28px 36px', fontSize: '22px' }
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
        borderRadius: '23px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        fontWeight: '900',
        opacity: disabled ? 0.5 : 1,
        transition: 'all 0.2s ease-in-out',
        boxShadow: '0 10px 12px rgba(0,0,0,0.07)'
      }}
      onMouseEnter={(e) => !disabled && (e.currentTarget.style.transform = 'translateY(-2px)')}
      onMouseLeave={(e) => !disabled && (e.currentTarget.style.transform = 'translateY(0)')}
    >
      {label}
    </button>
  );
};