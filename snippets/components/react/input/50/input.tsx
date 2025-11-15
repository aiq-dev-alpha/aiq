import React, { useState, CSSProperties, InputHTMLAttributes } from 'react';

interface InputTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  placeholder: string;
  error: string;
  success: string;
}

interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label?: string;
  hint?: string;
  error?: string;
  success?: string;
  variant?: 'outlined' | 'filled' | 'underlined' | 'flushed';
  inputSize?: 'sm' | 'md' | 'lg';
  theme?: Partial<InputTheme>;
  leftAddon?: React.ReactNode;
  rightAddon?: React.ReactNode;
  fullWidth?: boolean;
}

const defaultTheme: InputTheme = {
  primary: '#3b82f6',
  background: '#ffffff',
  border: '#d1d5db',
  text: '#111827',
  placeholder: '#9ca3af',
  error: '#ef4444',
  success: '#10b981'
};

export const Input: React.FC<InputProps> = ({
  label,
  hint,
  error,
  success,
  variant = 'outlined',
  inputSize = 'md',
  theme = {},
  leftAddon,
  rightAddon,
  fullWidth = false,
  className = '',
  disabled,
  ...props
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeMap: Record<string, CSSProperties> = {
    sm: { padding: '8px 12px', fontSize: '13px', minHeight: '36px' },
    md: { padding: '10px 14px', fontSize: '14px', minHeight: '42px' },
    lg: { padding: '12px 16px', fontSize: '16px', minHeight: '50px' }
  };

  const variantMap: Record<string, CSSProperties> = {
    outlined: {
      border: `2px solid ${error ? appliedTheme.error : success ? appliedTheme.success : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '12px',
      background: appliedTheme.background,
      boxShadow: isFocused ? `0 0 0 3px ${appliedTheme.primary}20` : 'none'
    },
    filled: {
      border: 'none',
      borderBottom: `2px solid ${error ? appliedTheme.error : success ? appliedTheme.success : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '12px 12px 0 0',
      background: isFocused ? `${appliedTheme.border}50` : `${appliedTheme.border}40`
    },
    underlined: {
      border: 'none',
      borderBottom: `2px solid ${error ? appliedTheme.error : success ? appliedTheme.success : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '0',
      background: 'transparent'
    },
    flushed: {
      border: 'none',
      borderBottom: `2px solid ${error ? appliedTheme.error : success ? appliedTheme.success : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '0',
      background: 'transparent',
      padding: '8px 0'
    }
  };

  const wrapperStyle: CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '6px',
    width: fullWidth ? '100%' : 'auto',
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const labelStyle: CSSProperties = {
    fontSize: '14px',
    fontWeight: 600,
    color: error ? appliedTheme.error : success ? appliedTheme.success : appliedTheme.text,
    marginBottom: '4px',
    transition: 'color 0.2s ease'
  };

  const containerStyle: CSSProperties = {
    ...sizeMap[inputSize],
    ...variantMap[variant],
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    transition: 'all 0.2s ease',
    opacity: disabled ? 0.6 : 1
  };

  const inputStyle: CSSProperties = {
    flex: 1,
    border: 'none',
    outline: 'none',
    background: 'transparent',
    color: appliedTheme.text,
    fontSize: 'inherit',
    fontFamily: 'inherit'
  };

  const messageStyle: CSSProperties = {
    fontSize: '12px',
    marginTop: '4px',
    color: error ? appliedTheme.error : success ? appliedTheme.success : appliedTheme.placeholder,
    fontWeight: error || success ? 500 : 400,
    display: 'flex',
    alignItems: 'center',
    gap: '4px'
  };

  return (
    <div style={wrapperStyle} className={className}>
      {label && <label style={labelStyle}>{label}</label>}
      <div style={containerStyle}>
        {leftAddon && <span>{leftAddon}</span>}
        <input
          style={inputStyle}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          disabled={disabled}
          {...props}
        />
        {rightAddon && <span>{rightAddon}</span>}
      </div>
      {(hint || error || success) && (
        <span style={messageStyle}>{error || success || hint}</span>
      )}
    </div>
  );
};
