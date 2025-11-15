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
    <div className={className} style={{ width: '100%', maxWidth: '350px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '17px', color: primary, fontSize: '17px', fontWeight: '400' }}>
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
          padding: '9px 13px',
          border: `1px solid ${primary}`,
          borderRadius: '16px',
          fontSize: '17px',
          outline: 'none',
          transition: 'all 0.2s ease-in-out',
          boxShadow: '0 11px 25px rgba(0,0,0,0.22)'
        }}
      />
    </div>
  );
};