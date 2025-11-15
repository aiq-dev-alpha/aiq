import React from 'react';

export interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  borderRadius: string;
  fontWeight: string | number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'solid' | 'outline' | 'ghost' | 'gradient';
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  theme?: Partial<ButtonTheme>;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  isLoading?: boolean;
  loadingText?: string;
  fullWidth?: boolean;
}

const defaultTheme: ButtonTheme = {
  primaryColor: '#8b5cf6',
  secondaryColor: '#a78bfa',
  textColor: '#ffffff',
  borderRadius: '0.75rem',
  fontWeight: 600
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'solid',
  size = 'md',
  theme = {},
  leftIcon,
  rightIcon,
  isLoading = false,
  loadingText,
  fullWidth = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeStyles = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.75rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    md: { padding: '0.625rem 1.25rem', fontSize: '1rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.125rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.25rem' }
  };

  const variantStyles = {
    solid: {
      background: `linear-gradient(135deg, ${appliedTheme.primaryColor}, ${appliedTheme.secondaryColor})`,
      color: appliedTheme.textColor,
      border: 'none'
    },
    outline: {
      background: 'transparent',
      color: appliedTheme.primaryColor,
      border: `2px solid ${appliedTheme.primaryColor}`
    },
    ghost: {
      background: 'transparent',
      color: appliedTheme.primaryColor,
      border: 'none'
    },
    gradient: {
      background: `linear-gradient(90deg, ${appliedTheme.primaryColor}, ${appliedTheme.secondaryColor})`,
      color: appliedTheme.textColor,
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: appliedTheme.borderRadius,
    fontWeight: appliedTheme.fontWeight,
    cursor: disabled || isLoading ? 'not-allowed' : 'pointer',
    opacity: disabled || isLoading ? 0.6 : 1,
    transition: 'all 0.2s ease',
    width: fullWidth ? '100%' : 'auto',
    ...sizeStyles[size],
    ...variantStyles[variant],
    ...style
  };

  return (
    <button disabled={disabled || isLoading} style={baseStyles} {...props}>
      {isLoading && <span style={{ animation: 'spin 1s linear infinite' }}>⏳</span>}
      {!isLoading && leftIcon && <span>{leftIcon}</span>}
      <span>{isLoading && loadingText ? loadingText : children}</span>
      {!isLoading && rightIcon && <span>{rightIcon}</span>}
    </button>
  );
};
