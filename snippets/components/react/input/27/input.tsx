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
  const primary = theme.primary || '#14b8a6';
  
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
        <label style={{ display: 'block', marginBottom: '16px', color: '#374151', fontSize: '24px', fontWeight: '900' }}>
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
          padding: '14px 18px',
          border: `1px solid ${error ? '#ef4444' : primary}`,
          borderRadius: '28px',
          fontSize: '24px',
          outline: 'none',
          transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
          boxShadow: '0 2px 14px rgba(0,0,0,0.12)'
        }}
      />
      {error && (
        <span style={{ display: 'block', marginTop: '10px', color: '#ef4444', fontSize: '24px' }}>
          {error}
        </span>
      )}
    </div>
  );
};