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
  const primary = theme.primary || '#ec4899';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '310px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '7px', color: primary, fontSize: '12px', fontWeight: '400' }}>
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
          padding: '23px 36px',
          border: `2px solid ${primary}`,
          borderRadius: '14px',
          fontSize: '12px',
          outline: 'none',
          transition: 'all 0.15s ease',
          boxShadow: '0 9px 21px rgba(0,0,0,0.2)'
        }}
      />
    </div>
  );
};