import React from 'react';

export interface InputTheme {
  accentColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
  focusColor: string;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  variant?: 'standard' | 'filled' | 'outlined';
  inputSize?: 'sm' | 'md' | 'lg';
  theme?: Partial<InputTheme>;
  label?: string;
  helperText?: string;
  errorText?: string;
  prefixIcon?: React.ReactNode;
  suffixIcon?: React.ReactNode;
  fullWidth?: boolean;
}

const defaultTheme: InputTheme = {
  accentColor: '#8b5cf6',
  backgroundColor: '#f8fafc',
  textColor: '#0f172a',
  borderColor: '#cbd5e1',
  focusColor: '#8b5cf6'
};

export const Input: React.FC<InputProps> = ({
  variant = 'outlined',
  inputSize = 'md',
  theme = {},
  label,
  helperText,
  errorText,
  prefixIcon,
  suffixIcon,
  fullWidth = false,
  style,
  ...props
}) => {
  const [isFocused, setIsFocused] = React.useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeConfig = {
    sm: { padding: '0.5rem 0.875rem', fontSize: '0.875rem' },
    md: { padding: '0.625rem 1rem', fontSize: '1rem' },
    lg: { padding: '0.75rem 1.25rem', fontSize: '1.125rem' }
  };

  const variantStyles = {
    standard: {
      backgroundColor: 'transparent',
      border: 'none',
      borderBottom: `2px solid ${errorText ? '#ef4444' : isFocused ? appliedTheme.focusColor : appliedTheme.borderColor}`,
      borderRadius: '0'
    },
    filled: {
      backgroundColor: appliedTheme.backgroundColor,
      border: 'none',
      borderBottom: `2px solid ${errorText ? '#ef4444' : isFocused ? appliedTheme.focusColor : 'transparent'}`,
      borderRadius: '0.375rem 0.375rem 0 0'
    },
    outlined: {
      backgroundColor: 'transparent',
      border: `2px solid ${errorText ? '#ef4444' : isFocused ? appliedTheme.focusColor : appliedTheme.borderColor}`,
      borderRadius: '0.5rem'
    }
  };

  const containerStyles: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    width: fullWidth ? '100%' : 'auto',
    gap: '0.375rem'
  };

  const wrapperStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '0.5rem',
    ...variantStyles[variant]
  };

  const inputStyles: React.CSSProperties = {
    flex: 1,
    border: 'none',
    outline: 'none',
    backgroundColor: 'transparent',
    color: appliedTheme.textColor,
    ...sizeConfig[inputSize],
    ...style
  };

  return (
    <div style={containerStyles}>
      {label && <label style={{ fontSize: '0.875rem', fontWeight: 600, color: appliedTheme.textColor }}>{label}</label>}
      <div style={wrapperStyles}>
        {prefixIcon && <span style={{ display: 'flex', paddingLeft: variant === 'outlined' ? '0.75rem' : '0' }}>{prefixIcon}</span>}
        <input
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          style={inputStyles}
          {...props}
        />
        {suffixIcon && <span style={{ display: 'flex', paddingRight: variant === 'outlined' ? '0.75rem' : '0' }}>{suffixIcon}</span>}
      </div>
      {(errorText || helperText) && (
        <span style={{ fontSize: '0.75rem', color: errorText ? '#ef4444' : '#64748b' }}>
          {errorText || helperText}
        </span>
      )}
    </div>
  );
};
