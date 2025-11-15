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
  const primary = theme.primary || '#f59e0b';
  
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
        <label style={{ display: 'block', marginBottom: '16px', color: '#374151', fontSize: '12px', fontWeight: '300' }}>
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
          padding: '12px 19px',
          border: `2px solid ${error ? '#ef4444' : primary}`,
          borderRadius: '7px',
          fontSize: '12px',
          outline: 'none',
          transition: 'all 0.3s ease-in-out',
          boxShadow: 'none'
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