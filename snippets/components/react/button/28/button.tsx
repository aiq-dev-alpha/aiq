import React from 'react';

export interface ButtonTheme {
  colors: {
    primary: string;
    secondary: string;
    accent: string;
    text: string;
    disabled: string;
  };
  borderRadius: string;
  fontFamily: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'filled' | 'tonal' | 'outlined' | 'text';
  colorScheme?: 'primary' | 'secondary' | 'accent';
  size?: 'small' | 'medium' | 'large';
  theme?: Partial<ButtonTheme>;
  startIcon?: React.ReactNode;
  endIcon?: React.ReactNode;
  block?: boolean;
}

const defaultTheme: ButtonTheme = {
  colors: {
    primary: '#ef4444',
    secondary: '#f59e0b',
    accent: '#8b5cf6',
    text: '#ffffff',
    disabled: '#9ca3af'
  },
  borderRadius: '0.5rem',
  fontFamily: 'system-ui, -apple-system, sans-serif'
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'filled',
  colorScheme = 'primary',
  size = 'medium',
  theme = {},
  startIcon,
  endIcon,
  block = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const baseColor = appliedTheme.colors[colorScheme];

  const sizeConfig = {
    small: { padding: '0.5rem 1rem', fontSize: '0.875rem', minHeight: '2rem' },
    medium: { padding: '0.75rem 1.5rem', fontSize: '1rem', minHeight: '2.75rem' },
    large: { padding: '1rem 2rem', fontSize: '1.125rem', minHeight: '3.5rem' }
  };

  const variantConfig = {
    filled: {
      backgroundColor: disabled ? appliedTheme.colors.disabled : baseColor,
      color: appliedTheme.colors.text,
      border: 'none'
    },
    tonal: {
      backgroundColor: disabled ? `${appliedTheme.colors.disabled}20` : `${baseColor}20`,
      color: disabled ? appliedTheme.colors.disabled : baseColor,
      border: 'none'
    },
    outlined: {
      backgroundColor: 'transparent',
      color: disabled ? appliedTheme.colors.disabled : baseColor,
      border: `2px solid ${disabled ? appliedTheme.colors.disabled : baseColor}`
    },
    text: {
      backgroundColor: 'transparent',
      color: disabled ? appliedTheme.colors.disabled : baseColor,
      border: 'none'
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
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
    width: block ? '100%' : 'auto',
    ...sizeConfig[size],
    ...variantConfig[variant],
    ...style
  };

  return (
    <button disabled={disabled} style={baseStyles} {...props}>
      {startIcon && <span style={{ display: 'flex', alignItems: 'center' }}>{startIcon}</span>}
      {children}
      {endIcon && <span style={{ display: 'flex', alignItems: 'center' }}>{endIcon}</span>}
    </button>
  );
};
