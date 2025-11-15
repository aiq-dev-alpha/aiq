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
  const primary = theme.primary || '#ef4444';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '320px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '4px', color: primary, fontSize: '12px', fontWeight: '500' }}>
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
          padding: '16px 24px',
          border: `1px solid ${primary}`,
          borderRadius: '16px',
          fontSize: '12px',
          outline: 'none',
          transition: 'all 0.3s ease-in-out',
          boxShadow: '0 10px 24px rgba(0,0,0,0.22)'
        }}
      />
    </div>
  );
};