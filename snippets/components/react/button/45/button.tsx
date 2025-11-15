import React from 'react';

export interface ButtonTheme {
  colors: {
    brand: string;
    neutral: string;
    success: string;
    warning: string;
    danger: string;
  };
  fonts: {
    family: string;
    weight: { light: number; normal: number; bold: number };
  };
  radius: { sm: string; md: string; lg: string; full: string };
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  intent?: 'brand' | 'neutral' | 'success' | 'warning' | 'danger';
  look?: 'filled' | 'tinted' | 'outlined' | 'minimal';
  measure?: 'sm' | 'md' | 'lg';
  rounding?: 'sm' | 'md' | 'lg' | 'full';
  theme?: Partial<ButtonTheme>;
  iconLeft?: React.ReactNode;
  iconRight?: React.ReactNode;
  working?: boolean;
  fullWidth?: boolean;
}

const defaultTheme: ButtonTheme = {
  colors: {
    brand: '#6366f1',
    neutral: '#64748b',
    success: '#10b981',
    warning: '#f59e0b',
    danger: '#ef4444'
  },
  fonts: {
    family: 'Inter, system-ui, sans-serif',
    weight: { light: 400, normal: 500, bold: 700 }
  },
  radius: { sm: '0.25rem', md: '0.5rem', lg: '0.75rem', full: '9999px' }
};

export const Button: React.FC<ButtonProps> = ({
  intent = 'brand',
  look = 'filled',
  measure = 'md',
  rounding = 'md',
  theme = {},
  iconLeft,
  iconRight,
  working = false,
  fullWidth = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const intentColor = appliedTheme.colors[intent];

  const measureMap = {
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem', fontWeight: appliedTheme.fonts.weight.normal },
    md: { padding: '0.625rem 1.25rem', fontSize: '1rem', fontWeight: appliedTheme.fonts.weight.normal },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.125rem', fontWeight: appliedTheme.fonts.weight.bold }
  };

  const lookMap = {
    filled: {
      backgroundColor: disabled ? '#9ca3af' : intentColor,
      color: '#ffffff',
      border: 'none'
    },
    tinted: {
      backgroundColor: disabled ? '#f3f4f6' : `${intentColor}20`,
      color: disabled ? '#9ca3af' : intentColor,
      border: 'none'
    },
    outlined: {
      backgroundColor: 'transparent',
      color: disabled ? '#9ca3af' : intentColor,
      border: `2px solid ${disabled ? '#9ca3af' : intentColor}`
    },
    minimal: {
      backgroundColor: 'transparent',
      color: disabled ? '#9ca3af' : intentColor,
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    fontFamily: appliedTheme.fonts.family,
    borderRadius: appliedTheme.radius[rounding],
    cursor: disabled || working ? 'not-allowed' : 'pointer',
    opacity: working ? 0.7 : 1,
    transition: 'all 0.2s ease',
    width: fullWidth ? '100%' : 'auto',
    ...measureMap[measure],
    ...lookMap[look],
    ...style
  };

  return (
    <button disabled={disabled || working} style={baseStyles} {...props}>
      {working ? (
        <span>⏳</span>
      ) : (
        <>
          {iconLeft && <span style={{ display: 'flex' }}>{iconLeft}</span>}
          <span>{children}</span>
          {iconRight && <span style={{ display: 'flex' }}>{iconRight}</span>}
        </>
      )}
    </button>
  );
};
