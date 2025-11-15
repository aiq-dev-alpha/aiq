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
  primary: '#ec4899',
  background: '#fdf2f8',
  border: '#fbcfe8',
  text: '#831843',
  error: '#be123c',
  success: '#15803d'
};

export const Input = forwardRef<HTMLInputElement, InputProps>(({
  label,
  helperText,
  error,
  variant = 'filled',
  size = 'md',
  theme = {},
  icon,
  iconPosition = 'right',
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
    sm: { padding: '8px 14px', fontSize: '13px', minHeight: '36px' },
    md: { padding: '12px 18px', fontSize: '15px', minHeight: '44px' },
    lg: { padding: '16px 22px', fontSize: '17px', minHeight: '52px' }
  };

  const variantStyles: Record<InputVariant, CSSProperties> = {
    default: {
      background: appliedTheme.background,
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '20px'
    },
    filled: {
      background: appliedTheme.background,
      border: `2px solid transparent`,
      borderBottom: `4px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '20px 20px 0 0',
      boxShadow: isFocused ? `0 -2px 12px ${appliedTheme.primary}20` : 'none'
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.border}`,
      borderRadius: '20px'
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
      borderRadius: '20px'
    }
  };

  const inputStyle: CSSProperties = {
    ...sizeStyles[size],
    ...variantStyles[variant],
    width: '100%',
    color: appliedTheme.text,
    fontFamily: 'inherit',
    outline: 'none',
    transition: 'all 0.35s ease-in-out',
    paddingLeft: icon && iconPosition === 'left' ? '48px' : sizeStyles[size].padding,
    paddingRight: (icon && iconPosition === 'right') || showClearButton ? '48px' : sizeStyles[size].padding,
    opacity: disabled ? 0.6 : 1,
    cursor: disabled ? 'not-allowed' : 'text'
  };

  const labelStyle: CSSProperties = {
    fontSize: variant === 'floating' && (isFocused || currentValue) ? '12px' : '14px',
    fontWeight: 600,
    color: error ? appliedTheme.error : isFocused ? appliedTheme.primary : appliedTheme.text,
    marginBottom: '8px',
    transition: 'all 0.35s ease-in-out',
    display: 'block'
  };

  const iconStyle: CSSProperties = {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    [iconPosition]: '16px',
    color: isFocused ? appliedTheme.primary : appliedTheme.border,
    transition: 'all 0.35s ease',
    pointerEvents: 'none'
  };

  const clearButtonStyle: CSSProperties = {
    position: 'absolute',
    right: '16px',
    top: '50%',
    transform: 'translateY(-50%)',
    background: 'transparent',
    border: `2px solid ${appliedTheme.border}`,
    color: appliedTheme.text,
    cursor: 'pointer',
    padding: '4px',
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '22px',
    height: '22px',
    fontSize: '12px',
    transition: 'all 0.2s ease'
  };

  const helperTextStyle: CSSProperties = {
    fontSize: '12px',
    color: error ? appliedTheme.error : appliedTheme.text,
    marginTop: '8px',
    opacity: 0.85,
    fontStyle: 'italic'
  };

  const counterStyle: CSSProperties = {
    fontSize: '12px',
    color: appliedTheme.text,
    opacity: 0.7,
    textAlign: 'right',
    marginTop: '4px',
    fontWeight: 500
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
            left: icon && iconPosition === 'left' ? '48px' : '18px',
            top: (isFocused || currentValue) ? '-9px' : '50%',
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
            onMouseEnter={(e) => {
              e.currentTarget.style.background = appliedTheme.primary;
              e.currentTarget.style.borderColor = appliedTheme.primary;
              e.currentTarget.style.color = 'white';
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.background = 'transparent';
              e.currentTarget.style.borderColor = appliedTheme.border;
              e.currentTarget.style.color = appliedTheme.text;
            }}
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
