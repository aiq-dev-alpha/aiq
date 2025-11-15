import React, { useState } from 'react';

export interface ComponentProps {
  value?: string;
  onChange?: (date: string) => void;
  theme?: { primary?: string };
  className?: string;
  label?: string;
  min?: string;
  max?: string;
}

export const Component: React.FC<ComponentProps> = ({
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  label,
  min,
  max
}) => {
  const [internalValue, setInternalValue] = useState('');
  const value = controlledValue || internalValue;
  const primary = theme.primary || '#8b5cf6';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '300px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '20px', color: primary, fontSize: '17px', fontWeight: '300' }}>
          {label}
        </label>
      )}
      <input
        type="date"
        value={value}
        onChange={handleChange}
        min={min}
        max={max}
        style={{
          width: '100%',
          padding: '18px 29px',
          border: `2px solid ${primary}`,
          borderRadius: '5px',
          fontSize: '17px',
          outline: 'none',
          transition: 'all 0.35s ease',
          boxShadow: '0 2px 4px rgba(0,0,0,0.06)'
        }}
      />
    </div>
  );
};