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
  const primary = theme.primary || '#f59e0b';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '280px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '13px', color: primary, fontSize: '20px', fontWeight: '800' }}>
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
          padding: '20px 27px',
          border: `2px solid ${primary}`,
          borderRadius: '19px',
          fontSize: '20px',
          outline: 'none',
          transition: 'all 0.3s ease',
          boxShadow: 'none'
        }}
      />
    </div>
  );
};