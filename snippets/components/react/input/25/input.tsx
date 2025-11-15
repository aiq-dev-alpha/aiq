import React, { useState } from 'react';

export interface ComponentProps {
  type?: string;
  placeholder?: string;
  value?: string;
  onChange?: (value: string) => void;
  theme?: { primary?: string };
  className?: string;
  label?: string;
  error?: string;
}

export const Component: React.FC<ComponentProps> = ({
  type = 'text',
  placeholder = 'Enter text',
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  label,
  error
}) => {
  const [internalValue, setInternalValue] = useState('');
  const value = controlledValue !== undefined ? controlledValue : internalValue;
  const primary = theme.primary || '#ef4444';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (controlledValue === undefined) {
      setInternalValue(newValue);
    }
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '400px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '6px', color: '#374151', fontSize: '14px', fontWeight: '400' }}>
          {label}
        </label>
      )}
      <input
        type={type}
        value={value}
        onChange={handleChange}
        placeholder={placeholder}
        style={{
          width: '100%',
          padding: '14px 24px',
          border: `1px solid ${error ? '#ef4444' : primary}`,
          borderRadius: '16px',
          fontSize: '14px',
          outline: 'none',
          transition: 'all 0.15s',
          boxShadow: '0 6px 16px rgba(0,0,0,0.18)'
        }}
      />
      {error && (
        <span style={{ display: 'block', marginTop: '4px', color: '#ef4444', fontSize: '12px' }}>
          {error}
        </span>
      )}
    </div>
  );
};