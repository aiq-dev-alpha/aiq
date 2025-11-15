import React from 'react';

export interface ButtonTheme {
  palette: {
    primary: string;
    secondary: string;
    success: string;
    warning: string;
    danger: string;
    info: string;
  };
  typography: {
    fontFamily: string;
    fontWeight: number;
  };
  shape: {
    borderRadius: string;
  };
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  color?: 'primary' | 'secondary' | 'success' | 'warning' | 'danger' | 'info';
  variant?: 'contained' | 'outlined' | 'text';
  size?: 'xs' | 'sm' | 'md' | 'lg';
  theme?: Partial<ButtonTheme>;
  startAdornment?: React.ReactNode;
  endAdornment?: React.ReactNode;
  fullWidth?: boolean;
  disableElevation?: boolean;
}

const defaultTheme: ButtonTheme = {
  palette: {
    primary: '#2563eb',
    secondary: '#7c3aed',
    success: '#16a34a',
    warning: '#ea580c',
    danger: '#dc2626',
    info: '#0891b2'
  },
  typography: {
    fontFamily: 'Inter, system-ui, sans-serif',
    fontWeight: 600
  },
  shape: {
    borderRadius: '0.5rem'
  }
};

export const Button: React.FC<ButtonProps> = ({
  color = 'primary',
  variant = 'contained',
  size = 'md',
  theme = {},
  startAdornment,
  endAdornment,
  fullWidth = false,
  disableElevation = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colorValue = appliedTheme.palette[color];

  const sizeMap = {
    xs: { padding: '0.25rem 0.625rem', fontSize: '0.75rem', minHeight: '1.75rem' },
    sm: { padding: '0.375rem 0.875rem', fontSize: '0.875rem', minHeight: '2rem' },
    md: { padding: '0.5rem 1.25rem', fontSize: '1rem', minHeight: '2.5rem' },
    lg: { padding: '0.625rem 1.5rem', fontSize: '1.125rem', minHeight: '3rem' }
  };

  const variantMap = {
    contained: {
      backgroundColor: colorValue,
      color: '#ffffff',
      border: 'none',
      boxShadow: disableElevation ? 'none' : '0 2px 4px rgba(0, 0, 0, 0.1)'
    },
    outlined: {
      backgroundColor: 'transparent',
      color: colorValue,
      border: `1.5px solid ${colorValue}`,
      boxShadow: 'none'
    },
    text: {
      backgroundColor: 'transparent',
      color: colorValue,
      border: 'none',
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    fontFamily: appliedTheme.typography.fontFamily,
    fontWeight: appliedTheme.typography.fontWeight,
    borderRadius: appliedTheme.shape.borderRadius,
    cursor: 'pointer',
    transition: 'all 0.2s ease-in-out',
    width: fullWidth ? '100%' : 'auto',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.025em',
    ...sizeMap[size],
    ...variantMap[variant],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {startAdornment && <span style={{ display: 'flex', alignItems: 'center' }}>{startAdornment}</span>}
      <span>{children}</span>
      {endAdornment && <span style={{ display: 'flex', alignItems: 'center' }}>{endAdornment}</span>}
    </button>
  );
};
