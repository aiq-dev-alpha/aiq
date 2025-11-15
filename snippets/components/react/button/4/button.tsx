import React from 'react';

export type ButtonVariant = 'primary' | 'secondary' | 'tertiary' | 'ghost' | 'link';
export type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

interface Theme {
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  borderRadius: string;
  fontFamily: string;
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  secondaryColor: '#64748b',
  textColor: '#ffffff',
  borderRadius: '0.5rem',
  fontFamily: 'system-ui, sans-serif'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  theme = {},
  styles = {},
  disabled,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeStyles: Record<ButtonSize, React.CSSProperties> = {
    xs: { padding: '0.25rem 0.5rem', fontSize: '0.75rem' },
    sm: { padding: '0.5rem 0.75rem', fontSize: '0.875rem' },
    md: { padding: '0.625rem 1rem', fontSize: '1rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.125rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.25rem' }
  };

  const variantStyles: Record<ButtonVariant, React.CSSProperties> = {
    primary: {
      backgroundColor: appliedTheme.primaryColor,
      color: appliedTheme.textColor,
      border: 'none'
    },
    secondary: {
      backgroundColor: appliedTheme.secondaryColor,
      color: appliedTheme.textColor,
      border: 'none'
    },
    tertiary: {
      backgroundColor: 'transparent',
      color: appliedTheme.primaryColor,
      border: `2px solid ${appliedTheme.primaryColor}`
    },
    ghost: {
      backgroundColor: 'transparent',
      color: appliedTheme.primaryColor,
      border: 'none'
    },
    link: {
      backgroundColor: 'transparent',
      color: appliedTheme.primaryColor,
      border: 'none',
      textDecoration: 'underline'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: appliedTheme.borderRadius,
    fontFamily: appliedTheme.fontFamily,
    fontWeight: 600,
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled || loading ? 0.6 : 1,
    transition: 'all 0.2s ease',
    width: fullWidth ? '100%' : 'auto',
    ...sizeStyles[size],
    ...variantStyles[variant],
    ...styles
  };

  return (
    <button style={baseStyles} disabled={disabled || loading} {...props}>
      {loading && <span style={{ animation: 'spin 1s linear infinite' }}>⏳</span>}
      {!loading && icon && iconPosition === 'left' && <span>{icon}</span>}
      {!loading && <span>{children}</span>}
      {!loading && icon && iconPosition === 'right' && <span>{icon}</span>}
    </button>
  );
};
