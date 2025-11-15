import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  placeholder?: string;
  type?: 'text' | 'email' | 'password' | 'number';
  error?: string;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  value?: string;
  onChange?: (value: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  label,
  placeholder = 'Enter text...',
  type = 'text',
  error,
  theme = {},
  className = '',
  value,
  onChange
}) => {
  const [focused, setFocused] = useState(false);
  const [internalValue, setInternalValue] = useState('');

  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  const currentValue = value !== undefined ? value : internalValue;

  return (
  <div className={className} style={{ width: '100%', maxWidth: '400px' }}>
  {label && (
  <label style={{
  display: 'block',
  marginBottom: '8px',
  color: text,
  fontSize: '14px',
  fontWeight: 600
  }}>
  {label}
  </label>
  )}
  <div style={{ position: 'relative' }}>
  <input
  type={type}
  placeholder={placeholder}
  value={currentValue}
  onChange={(e) => {
  const val = e.target.value;
  setInternalValue(val);
  onChange?.(val);
  }}
  onFocus={() => setFocused(true)}
  onBlur={() => setFocused(false)}
  style={{
  width: '100%',
  padding: '12px 16px',
  backgroundColor: background,
  color: text,
  border: `2px solid ${error ? '#ef4444' : focused ? primary : '#e5e7eb'}`,
  borderRadius: '8px',
  fontSize: '16px',
  outline: 'none',
  transition: 'all 200ms',
  boxShadow: focused ? `0 0 0 3px ${error ? '#ef444420' : primary + '20'}` : 'none'
  }}
  />
  {focused && (
  <div style={{
  position: 'absolute',
  bottom: '-2px',
  left: '0',
  right: '0',
  height: '2px',
  backgroundColor: error ? '#ef4444' : primary,
  animation: 'slideIn 200ms'
  }} />
  )}
  </div>
  {error && (
  <p style={{
  margin: '4px 0 0 0',
  color: '#ef4444',
  fontSize: '12px'
  }}>
  {error}
  </p>
  )}
  <style>{`
  @keyframes slideIn {
  from { transform: scaleX(0); }
  to { transform: scaleX(1); }
  }
  `}</style>
  </div>
  );
};