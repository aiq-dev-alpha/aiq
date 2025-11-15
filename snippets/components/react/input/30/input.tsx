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
  const primary = theme.primary || '#84cc16';
  
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
        <label style={{ display: 'block', marginBottom: '18px', color: '#374151', fontSize: '19px', fontWeight: '500' }}>
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
          padding: '16px 21px',
          border: `2px solid ${error ? '#ef4444' : primary}`,
          borderRadius: '26px',
          fontSize: '19px',
          outline: 'none',
          transition: 'all 0.35s ease',
          boxShadow: 'none'
        }}
      />
      {error && (
        <span style={{ display: 'block', marginTop: '6px', color: '#ef4444', fontSize: '19px' }}>
          {error}
        </span>
      )}
    </div>
  );
};