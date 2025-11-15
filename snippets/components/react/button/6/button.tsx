import React from 'react';

export type ButtonVariant = 'filled' | 'outlined' | 'text' | 'elevated' | 'tonal';
export type ButtonSize = 'compact' | 'regular' | 'comfortable' | 'spacious';

interface ButtonTheme {
  palette: {
    main: string;
    contrast: string;
    hover: string;
  };
  typography: {
    fontFamily: string;
    fontWeight: number;
    letterSpacing: string;
  };
  shape: {
    borderRadius: string;
    borderWidth: string;
  };
  elevation: string;
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  fullWidth?: boolean;
  isLoading?: boolean;
  startIcon?: React.ReactNode;
  endIcon?: React.ReactNode;
  buttonTheme?: Partial<ButtonTheme>;
  overrideStyles?: React.CSSProperties;
}

const defaultButtonTheme: ButtonTheme = {
  palette: {
    main: '#2563eb',
    contrast: '#ffffff',
    hover: '#1d4ed8'
  },
  typography: {
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
    fontWeight: 500,
    letterSpacing: '0.02em'
  },
  shape: {
    borderRadius: '0.5rem',
    borderWidth: '2px'
  },
  elevation: '0 2px 8px rgba(0, 0, 0, 0.15)'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'filled',
  size = 'regular',
  fullWidth = false,
  isLoading = false,
  startIcon,
  endIcon,
  buttonTheme = {},
  overrideStyles = {},
  disabled,
  ...props
}) => {
  const theme = { ...defaultButtonTheme, ...buttonTheme };

  const sizingMap: Record<ButtonSize, React.CSSProperties> = {
    compact: { padding: '0.375rem 0.75rem', fontSize: '0.813rem', minHeight: '2rem' },
    regular: { padding: '0.625rem 1.25rem', fontSize: '0.938rem', minHeight: '2.5rem' },
    comfortable: { padding: '0.875rem 1.75rem', fontSize: '1rem', minHeight: '3rem' },
    spacious: { padding: '1.125rem 2.25rem', fontSize: '1.063rem', minHeight: '3.5rem' }
  };

  const variantMap: Record<ButtonVariant, React.CSSProperties> = {
    filled: {
      backgroundColor: theme.palette.main,
      color: theme.palette.contrast,
      border: 'none',
      boxShadow: theme.elevation
    },
    outlined: {
      backgroundColor: 'transparent',
      color: theme.palette.main,
      border: `${theme.shape.borderWidth} solid ${theme.palette.main}`,
      boxShadow: 'none'
    },
    text: {
      backgroundColor: 'transparent',
      color: theme.palette.main,
      border: 'none',
      boxShadow: 'none'
    },
    elevated: {
      backgroundColor: theme.palette.main,
      color: theme.palette.contrast,
      border: 'none',
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.25)'
    },
    tonal: {
      backgroundColor: `${theme.palette.main}15`,
      color: theme.palette.main,
      border: 'none',
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: theme.shape.borderRadius,
    fontFamily: theme.typography.fontFamily,
    fontWeight: theme.typography.fontWeight,
    letterSpacing: theme.typography.letterSpacing,
    cursor: disabled || isLoading ? 'not-allowed' : 'pointer',
    opacity: disabled || isLoading ? 0.6 : 1,
    transition: 'all 0.2s ease-in-out',
    width: fullWidth ? '100%' : 'fit-content',
    ...sizingMap[size],
    ...variantMap[variant],
    ...overrideStyles
  };

  return (
    <button style={baseStyles} disabled={disabled || isLoading} {...props}>
      {isLoading && <span>⏳</span>}
      {!isLoading && startIcon && <span>{startIcon}</span>}
      {!isLoading && <span>{children}</span>}
      {!isLoading && endIcon && <span>{endIcon}</span>}
    </button>
  );
};
