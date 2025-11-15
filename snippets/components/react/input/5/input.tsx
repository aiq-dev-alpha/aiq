import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  placeholder?: string;
  value?: string;
  onChange?: (value: string) => void;
  error?: string;
  helperText?: string;
  required?: boolean;
  disabled?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Input Label',
  placeholder = 'Enter text...',
  value: controlledValue,
  onChange,
  error,
  helperText,
  required = false,
  disabled = false,
  theme = {},
  className = ''
}) => {
  const [internalValue, setInternalValue] = useState('');
  const [isFocused, setIsFocused] = useState(false);
  const primary = theme.primary || '#ec4899';
  const value = controlledValue !== undefined ? controlledValue : internalValue;

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  const newValue = e.target.value;
  setInternalValue(newValue);
  onChange?.(newValue);
  };

  const borderColor = error ? '#ef4444' : isFocused ? primary : '#d1d5db';

  return (
  <div className={className} style={{ width: '100%' }}>
  {label && (
  <label
  style={{
  display: 'block',
  fontSize: '14px',
  fontWeight: '500',
  color: '#374151',
  marginBottom: '6px'
  }}
  >
  {label}
  {required && <span style={{ color: '#ef4444', marginLeft: '4px' }}>*</span>}
  </label>
  )}
  <input
  type="text"
  value={value}
  onChange={handleChange}
  onFocus={() => setIsFocused(true)}
  onBlur={() => setIsFocused(false)}
  placeholder={placeholder}
  disabled={disabled}
  style={{
  width: '100%',
  padding: '10px 14px',
  fontSize: '15px',
  color: '#1f2937',
  backgroundColor: disabled ? '#f9fafb' : '#fff',
  border: `2px solid ${borderColor}`,
  borderRadius: '8px',
  outline: 'none',
  transition: 'all 0.2s ease',
  cursor: disabled ? 'not-allowed' : 'text'
  }}
  />
  {(error || helperText) && (
  <div
  style={{
  fontSize: '13px',
  color: error ? '#ef4444' : '#6b7280',
  marginTop: '6px'
  }}
  >
  {error || helperText}
  </div>
  )}
  </div>
  );
};