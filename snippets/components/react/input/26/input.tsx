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
  const primary = theme.primary || '#8b5cf6';
  
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
        <label style={{ display: 'block', marginBottom: '19px', color: '#374151', fontSize: '18px', fontWeight: '800' }}>
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
          padding: '26px 31px',
          border: `2px solid ${error ? '#ef4444' : primary}`,
          borderRadius: '35px',
          fontSize: '18px',
          outline: 'none',
          transition: 'all 0.2s ease',
          boxShadow: '0 17px 33px rgba(0,0,0,0.25)'
        }}
      />
      {error && (
        <span style={{ display: 'block', marginTop: '9px', color: '#ef4444', fontSize: '18px' }}>
          {error}
        </span>
      )}
    </div>
  );
};