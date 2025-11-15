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
        <label style={{ display: 'block', marginBottom: '8px', color: primary, fontSize: '18px', fontWeight: '800' }}>
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
          padding: '22px 26px',
          border: `1px solid ${primary}`,
          borderRadius: '18px',
          fontSize: '18px',
          outline: 'none',
          transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
          boxShadow: '0 8px 20px rgba(0,0,0,0.2)'
        }}
      />
    </div>
  );
};