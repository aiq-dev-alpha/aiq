import React from 'react';

export interface InputTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  errorColor: string;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  variant?: 'outlined' | 'filled' | 'underlined';
  size?: 'small' | 'medium' | 'large';
  theme?: Partial<InputTheme>;
  label?: string;
  errorMessage?: string;
  startIcon?: React.ReactNode;
  endIcon?: React.ReactNode;
  fullWidth?: boolean;
}

const defaultTheme: InputTheme = {
  primaryColor: '#8b5cf6',
  backgroundColor: '#f9fafb',
  textColor: '#111827',
  borderColor: '#e5e7eb',
  errorColor: '#dc2626'
};

export const Input: React.FC<InputProps> = ({
  variant = 'outlined',
  size = 'medium',
  theme = {},
  label,
  errorMessage,
  startIcon,
  endIcon,
  fullWidth = false,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeMap = {
    small: { padding: '0.5rem 0.75rem', fontSize: '0.875rem', height: '2rem' },
    medium: { padding: '0.625rem 1rem', fontSize: '1rem', height: '2.5rem' },
    large: { padding: '0.75rem 1.25rem', fontSize: '1.125rem', height: '3rem' }
  };

  const variantStyles = {
    outlined: {
      backgroundColor: 'transparent',
      border: `1px solid ${errorMessage ? appliedTheme.errorColor : appliedTheme.borderColor}`,
      borderRadius: '0.5rem'
    },
    filled: {
      backgroundColor: appliedTheme.backgroundColor,
      border: `1px solid transparent`,
      borderRadius: '0.5rem'
    },
    underlined: {
      backgroundColor: 'transparent',
      border: 'none',
      borderBottom: `2px solid ${errorMessage ? appliedTheme.errorColor : appliedTheme.borderColor}`,
      borderRadius: '0'
    }
  };

  const containerStyles: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.375rem',
    width: fullWidth ? '100%' : 'auto'
  };

  const inputWrapperStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '0.5rem',
    ...variantStyles[variant],
    ...style
  };

  const inputStyles: React.CSSProperties = {
    flex: 1,
    border: 'none',
    outline: 'none',
    backgroundColor: 'transparent',
    color: appliedTheme.textColor,
    ...sizeMap[size]
  };

  return (
    <div style={containerStyles}>
      {label && <label style={{ fontSize: '0.875rem', fontWeight: 500, color: appliedTheme.textColor }}>{label}</label>}
      <div style={inputWrapperStyles}>
        {startIcon && <span style={{ display: 'flex', paddingLeft: '0.5rem' }}>{startIcon}</span>}
        <input style={inputStyles} {...props} />
        {endIcon && <span style={{ display: 'flex', paddingRight: '0.5rem' }}>{endIcon}</span>}
      </div>
      {errorMessage && <span style={{ fontSize: '0.75rem', color: appliedTheme.errorColor }}>{errorMessage}</span>}
    </div>
  );
};
