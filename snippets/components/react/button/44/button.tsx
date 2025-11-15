import React from 'react';

export interface ButtonTheme {
  colorPalette: Record<string, { main: string; contrast: string; hover: string }>;
  borderWidth: number;
  transitionSpeed: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  colorScheme?: 'blue' | 'green' | 'red' | 'yellow' | 'purple' | 'gray';
  buttonVariant?: 'solid' | 'outline' | 'ghost' | 'link' | 'soft';
  buttonSize?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl';
  theme?: Partial<ButtonTheme>;
  leftElement?: React.ReactNode;
  rightElement?: React.ReactNode;
  isFullWidth?: boolean;
  isDisabled?: boolean;
}

const defaultTheme: ButtonTheme = {
  colorPalette: {
    blue: { main: '#2563eb', contrast: '#ffffff', hover: '#1d4ed8' },
    green: { main: '#059669', contrast: '#ffffff', hover: '#047857' },
    red: { main: '#dc2626', contrast: '#ffffff', hover: '#b91c1c' },
    yellow: { main: '#d97706', contrast: '#ffffff', hover: '#b45309' },
    purple: { main: '#7c3aed', contrast: '#ffffff', hover: '#6d28d9' },
    gray: { main: '#4b5563', contrast: '#ffffff', hover: '#374151' }
  },
  borderWidth: 2,
  transitionSpeed: '150ms'
};

export const Button: React.FC<ButtonProps> = ({
  colorScheme = 'blue',
  buttonVariant = 'solid',
  buttonSize = 'md',
  theme = {},
  leftElement,
  rightElement,
  isFullWidth = false,
  isDisabled = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colors = appliedTheme.colorPalette[colorScheme];

  const sizeMap = {
    xs: { padding: '0.25rem 0.625rem', fontSize: '0.75rem', height: '1.5rem' },
    sm: { padding: '0.375rem 0.875rem', fontSize: '0.875rem', height: '2rem' },
    md: { padding: '0.5rem 1.125rem', fontSize: '1rem', height: '2.5rem' },
    lg: { padding: '0.625rem 1.375rem', fontSize: '1.125rem', height: '3rem' },
    xl: { padding: '0.75rem 1.625rem', fontSize: '1.25rem', height: '3.5rem' },
    '2xl': { padding: '1rem 2rem', fontSize: '1.5rem', height: '4rem' }
  };

  const variantStyles = {
    solid: {
      backgroundColor: isDisabled ? '#9ca3af' : colors.main,
      color: colors.contrast,
      border: 'none'
    },
    outline: {
      backgroundColor: 'transparent',
      color: isDisabled ? '#9ca3af' : colors.main,
      border: `${appliedTheme.borderWidth}px solid ${isDisabled ? '#9ca3af' : colors.main}`
    },
    ghost: {
      backgroundColor: isDisabled ? 'transparent' : `${colors.main}15`,
      color: isDisabled ? '#9ca3af' : colors.main,
      border: 'none'
    },
    link: {
      backgroundColor: 'transparent',
      color: isDisabled ? '#9ca3af' : colors.main,
      border: 'none',
      textDecoration: 'underline'
    },
    soft: {
      backgroundColor: isDisabled ? '#f3f4f6' : `${colors.main}25`,
      color: isDisabled ? '#9ca3af' : colors.main,
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: '0.5rem',
    fontWeight: 600,
    cursor: isDisabled ? 'not-allowed' : 'pointer',
    transition: `all ${appliedTheme.transitionSpeed} ease`,
    width: isFullWidth ? '100%' : 'auto',
    ...sizeMap[buttonSize],
    ...variantStyles[buttonVariant],
    ...style
  };

  return (
    <button disabled={isDisabled} style={baseStyles} {...props}>
      {leftElement && <span style={{ display: 'flex', alignItems: 'center' }}>{leftElement}</span>}
      <span>{children}</span>
      {rightElement && <span style={{ display: 'flex', alignItems: 'center' }}>{rightElement}</span>}
    </button>
  );
};
