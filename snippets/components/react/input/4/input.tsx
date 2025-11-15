import React, { useState, CSSProperties, ReactNode, forwardRef } from 'react';

interface InputTheme {
  primary: string;
  background: string;
  border: string;
  text: string;
  error: string;
  success: string;
}

export type InputSize = 'sm' | 'md' | 'lg';
export type InputVariant = 'default' | 'filled' | 'outlined' | 'underlined' | 'floating';
export type IconPosition = 'left' | 'right';

interface InputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label?: string;
  helperText?: string;
  error?: string;
  variant?: InputVariant;
  size?: InputSize;
  theme?: Partial<InputTheme>;
  icon?: ReactNode;
  iconPosition?: IconPosition;
  showClearButton?: boolean;
  showCharacterCount?: boolean;
  maxLength?: number;
}

const defaultTheme: InputTheme = {
  primary: '#f59e0b',
  background: '#fffbeb',
  border: '#fde68a',
  text: '#78350f',
  error: '#dc2626',
  success: '#059669'
};

export const Input = forwardRef<HTMLInputElement, InputProps>(({
  label,
  helperText,
  error,
  variant = 'default',
  size = 'md',
  theme = {},
  icon,
  iconPosition = 'left',
  showClearButton = false,
  showCharacterCount = false,
  maxLength,
  value = '',
  onChange,
  disabled = false,
  required = false,
  ...props
}, ref) => {
  const [isFocused, setIsFocused] = useState(false);
  const [internalValue, setInternalValue] = useState(value);
  const appliedTheme = { ...defaultTheme, ...theme };

  const currentValue = value !== undefined ? value : internalValue;
  const characterCount = String(currentValue).length;

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInternalValue(e.target.value);
    onChange?.(e);
  };

  const handleClear = () => {
    const event = {
      target: { value: '' }
    } as React.ChangeEvent<HTMLInputElement>;
    setInternalValue('');
    onChange?.(event);
  };

  const sizeStyles: Record<InputSize, CSSProperties> = {
    sm: { padding: '9px 13px', fontSize: '13px', minHeight: '38px' },
    md: { padding: '13px 17px', fontSize: '15px', minHeight: '46px' },
    lg: { padding: '17px 21px', fontSize: '17px', minHeight: '54px' }
  };

  const variantStyles: Record<InputVariant, CSSProperties> = {
    default: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '16px',
      boxShadow: isFocused ? `0 8px 24px ${appliedTheme.primary}30` : 'none'
    },
    filled: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : 'transparent'}`,
      borderBottom: `3px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '16px 16px 0 0'
    },
    outlined: {
      background: 'transparent',
      border: `3px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '16px'
    },
    underlined: {
      background: 'transparent',
      border: 'none',
      borderBottom: `3px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '0',
      paddingLeft: '0',
      paddingRight: '0'
    },
    floating: {
      background: 'white',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '16px'
    }
  };

  const inputStyle: CSSProperties = {
    ...sizeStyles[size],
    ...variantStyles[variant],
    width: '100%',
    color: appliedTheme.text,
    fontFamily: 'inherit',
    fontWeight: 500,
    outline: 'none',
    transition: 'all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)',
    paddingLeft: icon && iconPosition === 'left' ? '46px' : variant === 'underlined' ? '0' : sizeStyles[size].padding,
    paddingRight: ((icon && iconPosition === 'right') || showClearButton) ? '46px' : variant === 'underlined' ? '0' : sizeStyles[size].padding,
    opacity: disabled ? 0.5 : 1,
    cursor: disabled ? 'not-allowed' : 'text'
  };

  const labelStyle: CSSProperties = {
    fontSize: variant === 'floating' && (isFocused || currentValue) ? '12px' : '15px',
    fontWeight: 700,
    color: error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.text,
    marginBottom: '8px',
    transition: 'all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)',
    display: 'block',
    letterSpacing: '0.5px'
  };

  const iconStyle: CSSProperties = {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    [iconPosition]: '16px',
    color: isFocused ? appliedTheme.primary : appliedTheme.border,
    transition: 'all 0.3s ease',
    pointerEvents: 'none',
    fontSize: '18px'
  };

  const clearButtonStyle: CSSProperties = {
    position: 'absolute',
    right: '14px',
    top: '50%',
    transform: 'translateY(-50%)',
    background: appliedTheme.primary,
    border: 'none',
    color: 'white',
    cursor: 'pointer',
    padding: '6px',
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '24px',
    height: '24px',
    fontSize: '14px',
    fontWeight: 'bold',
    transition: 'all 0.2s ease',
    opacity: 0.8
  };

  const helperTextStyle: CSSProperties = {
    fontSize: '13px',
    fontWeight: 500,
    color: error ? appliedTheme.error : appliedTheme.text,
    marginTop: '8px',
    opacity: 0.9
  };

  const counterStyle: CSSProperties = {
    fontSize: '12px',
    fontWeight: 600,
    color: appliedTheme.text,
    opacity: 0.6,
    textAlign: 'right',
    marginTop: '6px'
  };

  return (
    <div style={{ width: '100%' }}>
      {label && variant !== 'floating' && (
        <label style={labelStyle}>
          {label}
          {required && <span style={{ color: appliedTheme.error, marginLeft: '4px' }}>*</span>}
        </label>
      )}
      <div style={{ position: 'relative' }}>
        {variant === 'floating' && label && (
          <label style={{
            ...labelStyle,
            position: 'absolute',
            left: icon && iconPosition === 'left' ? '46px' : '17px',
            top: (isFocused || currentValue) ? '-10px' : '50%',
            transform: (isFocused || currentValue) ? 'translateY(0)' : 'translateY(-50%)',
            background: 'white',
            padding: '0 8px',
            pointerEvents: 'none',
            zIndex: 1
          }}>
            {label}
            {required && <span style={{ color: appliedTheme.error, marginLeft: '4px' }}>*</span>}
          </label>
        )}
        {icon && <span style={iconStyle}>{icon}</span>}
        <input
          ref={ref}
          value={currentValue}
          onChange={handleChange}
          disabled={disabled}
          required={required}
          maxLength={maxLength}
          style={inputStyle}
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          {...props}
        />
        {showClearButton && currentValue && !disabled && (
          <button
            type="button"
            onClick={handleClear}
            style={clearButtonStyle}
            onMouseEnter={(e) => { e.currentTarget.style.opacity = '1'; e.currentTarget.style.transform = 'translateY(-50%) scale(1.1)'; }}
            onMouseLeave={(e) => { e.currentTarget.style.opacity = '0.8'; e.currentTarget.style.transform = 'translateY(-50%) scale(1)'; }}
          >
            ✕
          </button>
        )}
      </div>
      {error && <div style={helperTextStyle}>{error}</div>}
      {!error && helperText && <div style={helperTextStyle}>{helperText}</div>}
      {showCharacterCount && maxLength && (
        <div style={counterStyle}>{characterCount}/{maxLength}</div>
      )}
    </div>
  );
});

Input.displayName = 'Input';
