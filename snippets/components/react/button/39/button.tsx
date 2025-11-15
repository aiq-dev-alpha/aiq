import React from 'react';

export interface ButtonTheme {
  colorSet: {
    primary: string;
    secondary: string;
    tertiary: string;
    quaternary: string;
  };
  spacing: { x: string; y: string };
  rounding: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  rank?: 'primary' | 'secondary' | 'tertiary' | 'quaternary';
  presentation?: 'filled' | 'stroked' | 'faint' | 'bare';
  magnitude?: 'tiny' | 'small' | 'normal' | 'large' | 'huge';
  theme?: Partial<ButtonTheme>;
  prefixIcon?: React.ReactNode;
  suffixIcon?: React.ReactNode;
  isBusy?: boolean;
  occupyFull?: boolean;
}

const defaultTheme: ButtonTheme = {
  colorSet: {
    primary: '#6366f1',
    secondary: '#ec4899',
    tertiary: '#14b8a6',
    quaternary: '#f59e0b'
  },
  spacing: { x: '1rem', y: '0.5rem' },
  rounding: '0.5rem'
};

export const Button: React.FC<ButtonProps> = ({
  rank = 'primary',
  presentation = 'filled',
  magnitude = 'normal',
  theme = {},
  prefixIcon,
  suffixIcon,
  isBusy = false,
  occupyFull = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const rankColor = appliedTheme.colorSet[rank];

  const magnitudeConfig = {
    tiny: { paddingX: '0.625rem', paddingY: '0.3125rem', fontSize: '0.75rem' },
    small: { paddingX: '0.875rem', paddingY: '0.4375rem', fontSize: '0.875rem' },
    normal: { paddingX: '1.125rem', paddingY: '0.5625rem', fontSize: '1rem' },
    large: { paddingX: '1.375rem', paddingY: '0.6875rem', fontSize: '1.125rem' },
    huge: { paddingX: '1.75rem', paddingY: '0.875rem', fontSize: '1.25rem' }
  };

  const presentationConfig = {
    filled: {
      backgroundColor: disabled ? '#9ca3af' : rankColor,
      color: '#ffffff',
      border: 'none'
    },
    stroked: {
      backgroundColor: 'transparent',
      color: disabled ? '#9ca3af' : rankColor,
      border: `2px solid ${disabled ? '#9ca3af' : rankColor}`
    },
    faint: {
      backgroundColor: disabled ? '#f3f4f6' : `${rankColor}18`,
      color: disabled ? '#9ca3af' : rankColor,
      border: 'none'
    },
    bare: {
      backgroundColor: 'transparent',
      color: disabled ? '#9ca3af' : rankColor,
      border: 'none',
      textDecoration: 'underline'
    }
  };

  const config = magnitudeConfig[magnitude];
  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    padding: `${config.paddingY} ${config.paddingX}`,
    fontSize: config.fontSize,
    borderRadius: appliedTheme.rounding,
    fontWeight: 600,
    cursor: disabled || isBusy ? 'not-allowed' : 'pointer',
    opacity: isBusy ? 0.7 : 1,
    transition: 'all 0.2s ease',
    width: occupyFull ? '100%' : 'auto',
    ...presentationConfig[presentation],
    ...style
  };

  return (
    <button disabled={disabled || isBusy} style={baseStyles} {...props}>
      {isBusy ? '⏳' : prefixIcon && <span style={{ display: 'flex' }}>{prefixIcon}</span>}
      <span>{children}</span>
      {!isBusy && suffixIcon && <span style={{ display: 'flex' }}>{suffixIcon}</span>}
    </button>
  );
};
