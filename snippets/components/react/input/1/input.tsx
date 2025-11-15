import React, { useState, CSSProperties, ReactNode, forwardRef } from 'react';

interface InputTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  placeholder: string;
  error: string;
  success: string;
  focus: string;
}

export type InputSize = 'sm' | 'md' | 'lg';
export type InputVariant = 'default' | 'filled' | 'underline' | 'bordered';
export type InputState = 'default' | 'error' | 'success' | 'warning';

interface InputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label?: string;
  helperText?: string;
  error?: string;
  success?: string;
  inputSize?: InputSize;
  variant?: InputVariant;
  state?: InputState;
  leftIcon?: ReactNode;
  rightIcon?: ReactNode;
  theme?: Partial<InputTheme>;
  fullWidth?: boolean;
}

const defaultTheme: InputTheme = {
  primary: '#3b82f6',
  background: '#ffffff',
  border: '#d1d5db',
  text: '#111827',
  placeholder: '#9ca3af',
  error: '#ef4444',
  success: '#10b981',
  focus: '#60a5fa'
};

export const Input = forwardRef<HTMLInputElement, InputProps>(({
  label,
  helperText,
  error,
  success,
  inputSize = 'md',
  variant = 'default',
  state = 'default',
  leftIcon,
  rightIcon,
  theme = {},
  fullWidth = false,
  className = '',
  ...props
}, ref) => {
  const [isFocused, setIsFocused] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const currentState = error ? 'error' : success ? 'success' : state;
  const currentMessage = error || success || helperText;

  const stateColors = {
    default: appliedTheme.border,
    error: appliedTheme.error,
    success: appliedTheme.success,
    warning: '#f59e0b'
  };

  const sizeStyles: Record<InputSize, CSSProperties> = {
    sm: { padding: '8px 14px', fontSize: '13px', minHeight: '36px' },
    md: { padding: '12px 16px', fontSize: '15px', minHeight: '44px' },
    lg: { padding: '14px 20px', fontSize: '17px', minHeight: '52px' }
  };

  const variantStyles: Record<InputVariant, CSSProperties> = {
    default: {
      background: appliedTheme.background,
      border: `2px solid ${isFocused ? appliedTheme.focus : stateColors[currentState]}`,
      borderRadius: '10px'
    },
    filled: {
      background: `${appliedTheme.primary}08`,
      border: `2px solid transparent`,
      borderBottom: `2px solid ${isFocused ? appliedTheme.primary : stateColors[currentState]}`,
      borderRadius: '10px 10px 0 0'
    },
    underline: {
      background: 'transparent',
      border: 'none',
      borderBottom: `2px solid ${isFocused ? appliedTheme.primary : stateColors[currentState]}`,
      borderRadius: '0'
    },
    bordered: {
      background: appliedTheme.background,
      border: `3px solid ${isFocused ? appliedTheme.primary : stateColors[currentState]}`,
      borderRadius: '12px'
    }
  };

  const wrapperStyle: CSSProperties = {
    width: fullWidth ? '100%' : 'auto',
    display: 'inline-flex',
    flexDirection: 'column',
    gap: '6px'
  };

  const labelStyle: CSSProperties = {
    fontSize: '14px',
    fontWeight: 600,
    color: appliedTheme.text,
    marginBottom: '4px',
    letterSpacing: '0.3px'
  };

  const inputContainerStyle: CSSProperties = {
    position: 'relative',
    display: 'flex',
    alignItems: 'center',
    width: '100%'
  };

  const inputStyle: CSSProperties = {
    ...sizeStyles[inputSize],
    ...variantStyles[variant],
    width: '100%',
    color: appliedTheme.text,
    fontFamily: 'inherit',
    outline: 'none',
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    paddingLeft: leftIcon ? '44px' : sizeStyles[inputSize].padding,
    paddingRight: rightIcon ? '44px' : sizeStyles[inputSize].padding,
    boxShadow: isFocused ? `0 4px 12px ${appliedTheme.primary}20` : 'none'
  };

  const iconStyle: CSSProperties = {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    color: isFocused ? appliedTheme.primary : appliedTheme.placeholder,
    transition: 'color 0.2s ease',
    pointerEvents: 'none'
  };

  const leftIconStyle: CSSProperties = {
    ...iconStyle,
    left: '14px'
  };

  const rightIconStyle: CSSProperties = {
    ...iconStyle,
    right: '14px'
  };

  const messageStyle: CSSProperties = {
    fontSize: '12px',
    fontWeight: 500,
    color: stateColors[currentState],
    marginTop: '4px',
    letterSpacing: '0.2px'
  };

  return (
    <div style={wrapperStyle} className={className}>
      {label && <label style={labelStyle}>{label}</label>}
      <div style={inputContainerStyle}>
        {leftIcon && <span style={leftIconStyle}>{leftIcon}</span>}
        <input
          ref={ref}
          style={inputStyle}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          {...props}
        />
        {rightIcon && <span style={rightIconStyle}>{rightIcon}</span>}
      </div>
      {currentMessage && <span style={messageStyle}>{currentMessage}</span>}
    </div>
  );
});

Input.displayName = 'Input';
