import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  placeholder?: string;
  icon?: React.ReactNode;
  helperText?: string;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  value?: string;
  onChange?: (value: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  label,
  placeholder = 'Type here...',
  icon,
  helperText,
  theme = {},
  className = '',
  value,
  onChange
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [hasValue, setHasValue] = useState(false);

  const primary = theme.primary || '#10b981';
  const background = theme.background || '#f9fafb';
  const text = theme.text || '#1f2937';

  return (
  <div className={className} style={{ width: '100%', maxWidth: '500px' }}>
  <div style={{
  position: 'relative',
  backgroundColor: background,
  borderRadius: '12px',
  border: `2px solid ${isFocused ? primary : 'transparent'}`,
  transition: 'all 200ms',
  overflow: 'hidden'
  }}>
  {label && (
  <label style={{
  position: 'absolute',
  left: icon ? '48px' : '16px',
  top: isFocused || hasValue ? '8px' : '50%',
  transform: isFocused || hasValue ? 'translateY(0)' : 'translateY(-50%)',
  fontSize: isFocused || hasValue ? '12px' : '16px',
  color: isFocused ? primary : `${text}80`,
  fontWeight: 500,
  transition: 'all 200ms',
  pointerEvents: 'none'
  }}>
  {label}
  </label>
  )}
  {icon && (
  <div style={{
  position: 'absolute',
  left: '16px',
  top: '50%',
  transform: 'translateY(-50%)',
  color: isFocused ? primary : `${text}60`
  }}>
  {icon}
  </div>
  )}
  <input
  placeholder={isFocused ? placeholder : ''}
  value={value}
  onChange={(e) => {
  const val = e.target.value;
  setHasValue(val.length > 0);
  onChange?.(val);
  }}
  onFocus={() => setIsFocused(true)}
  onBlur={() => setIsFocused(false)}
  style={{
  width: '100%',
  padding: label ? '28px 16px 8px' : '16px',
  paddingLeft: icon ? '48px' : '16px',
  backgroundColor: 'transparent',
  color: text,
  border: 'none',
  fontSize: '16px',
  outline: 'none'
  }}
  />
  </div>
  {helperText && (
  <p style={{
  margin: '8px 0 0 16px',
  color: `${text}60`,
  fontSize: '14px'
  }}>
  {helperText}
  </p>
  )}
  </div>
  );
};