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
  primary: '#10b981',
  background: '#ecfdf5',
  border: '#a7f3d0',
  text: '#064e3b',
  error: '#dc2626',
  success: '#059669'
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
    sm: { padding: '7px 13px', fontSize: '13px', minHeight: '35px' },
    md: { padding: '11px 17px', fontSize: '15px', minHeight: '43px' },
    lg: { padding: '15px 21px', fontSize: '17px', minHeight: '51px' }
  };

  const variantStyles: Record<InputVariant, CSSProperties> = {
    default: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '6px'
    },
    filled: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : 'transparent'}`,
      borderBottom: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '6px 6px 0 0'
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '6px',
      boxShadow: isFocused ? `0 0 0 4px ${appliedTheme.primary}15` : 'none'
    },
    underlined: {
      background: 'transparent',
      border: 'none',
      borderBottom: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '0'
    },
    floating: {
      background: 'white',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '6px'
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
    transition: 'all 0.2s ease',
    paddingLeft: icon && iconPosition === 'left' ? '40px' : sizeStyles[size].padding,
    paddingRight: (icon && iconPosition === 'right') || showClearButton ? '40px' : sizeStyles[size].padding,
    opacity: disabled ? 0.5 : 1,
    cursor: disabled ? 'not-allowed' : 'text'
  };

  const labelStyle: CSSProperties = {
    fontSize: variant === 'floating' && (isFocused || currentValue) ? '11px' : '13px',
    fontWeight: 700,
    color: error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.text,
    marginBottom: '6px',
    transition: 'all 0.2s ease',
    display: 'block',
    textTransform: 'uppercase',
    letterSpacing: '0.5px'
  };

  const iconStyle: CSSProperties = {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    [iconPosition]: '13px',
    color: isFocused ? appliedTheme.primary : appliedTheme.border,
    transition: 'color 0.2s ease',
    pointerEvents: 'none'
  };

  const clearButtonStyle: CSSProperties = {
    position: 'absolute',
    right: '11px',
    top: '50%',
    transform: 'translateY(-50%)',
    background: appliedTheme.error,
    border: 'none',
    color: 'white',
    cursor: 'pointer',
    padding: '3px',
    borderRadius: '4px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '18px',
    height: '18px',
    fontSize: '11px',
    transition: 'all 0.2s ease'
  };

  const helperTextStyle: CSSProperties = {
    fontSize: '11px',
    fontWeight: 500,
    color: error ? appliedTheme.error : appliedTheme.text,
    marginTop: '5px',
    opacity: 0.85
  };

  const counterStyle: CSSProperties = {
    fontSize: '11px',
    color: appliedTheme.text,
    opacity: 0.65,
    textAlign: 'right',
    marginTop: '4px',
    fontWeight: 600
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
            left: icon && iconPosition === 'left' ? '40px' : '17px',
            top: (isFocused || currentValue) ? '-9px' : '50%',
            transform: (isFocused || currentValue) ? 'translateY(0)' : 'translateY(-50%)',
            background: 'white',
            padding: '0 5px',
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
            onMouseEnter={(e) => { e.currentTarget.style.opacity = '0.8'; }}
            onMouseLeave={(e) => { e.currentTarget.style.opacity = '1'; }}
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
