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
  primary: '#0ea5e9',
  background: '#f0f9ff',
  border: '#bae6fd',
  text: '#0c4a6e',
  error: '#e11d48',
  success: '#16a34a'
};

export const Input = forwardRef<HTMLInputElement, InputProps>(({
  label,
  helperText,
  error,
  variant = 'outlined',
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
    sm: { padding: '7px 11px', fontSize: '13px', minHeight: '34px' },
    md: { padding: '11px 15px', fontSize: '15px', minHeight: '42px' },
    lg: { padding: '15px 19px', fontSize: '17px', minHeight: '50px' }
  };

  const variantStyles: Record<InputVariant, CSSProperties> = {
    default: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '8px'
    },
    filled: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : 'transparent'}`,
      borderBottom: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '8px 8px 0 0'
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '10px',
      boxShadow: isFocused ? `0 0 0 3px ${appliedTheme.primary}20` : 'none'
    },
    underlined: {
      background: 'transparent',
      border: 'none',
      borderBottom: `3px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '0'
    },
    floating: {
      background: 'white',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '8px'
    }
  };

  const inputStyle: CSSProperties = {
    ...sizeStyles[size],
    ...variantStyles[variant],
    width: '100%',
    color: appliedTheme.text,
    fontFamily: 'inherit',
    outline: 'none',
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    paddingLeft: icon && iconPosition === 'left' ? '42px' : sizeStyles[size].padding,
    paddingRight: (icon && iconPosition === 'right') || showClearButton ? '42px' : sizeStyles[size].padding,
    opacity: disabled ? 0.5 : 1,
    cursor: disabled ? 'not-allowed' : 'text'
  };

  const labelStyle: CSSProperties = {
    fontSize: variant === 'floating' && (isFocused || currentValue) ? '11px' : '14px',
    fontWeight: 600,
    color: error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.text,
    marginBottom: '6px',
    transition: 'all 0.25s ease',
    display: 'block'
  };

  const iconStyle: CSSProperties = {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    [iconPosition]: '12px',
    color: isFocused ? appliedTheme.primary : appliedTheme.border,
    transition: 'color 0.25s ease',
    pointerEvents: 'none'
  };

  const clearButtonStyle: CSSProperties = {
    position: 'absolute',
    right: '10px',
    top: '50%',
    transform: 'translateY(-50%)',
    background: appliedTheme.border,
    border: 'none',
    color: appliedTheme.text,
    cursor: 'pointer',
    padding: '4px',
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '20px',
    height: '20px',
    fontSize: '12px',
    transition: 'all 0.2s ease'
  };

  const helperTextStyle: CSSProperties = {
    fontSize: '12px',
    color: error ? appliedTheme.error : appliedTheme.text,
    marginTop: '6px',
    opacity: 0.8
  };

  const counterStyle: CSSProperties = {
    fontSize: '11px',
    color: appliedTheme.text,
    opacity: 0.6,
    textAlign: 'right',
    marginTop: '4px'
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
            left: icon && iconPosition === 'left' ? '42px' : '15px',
            top: (isFocused || currentValue) ? '-10px' : '50%',
            transform: (isFocused || currentValue) ? 'translateY(0)' : 'translateY(-50%)',
            background: 'white',
            padding: '0 6px',
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
            onMouseEnter={(e) => { e.currentTarget.style.background = appliedTheme.primary; e.currentTarget.style.color = 'white'; }}
            onMouseLeave={(e) => { e.currentTarget.style.background = appliedTheme.border; e.currentTarget.style.color = appliedTheme.text; }}
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
