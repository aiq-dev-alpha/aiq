import React, { useState } from 'react';

export interface ComponentProps {
  min?: number;
  max?: number;
  value?: [number, number];
  onChange?: (value: [number, number]) => void;
  theme?: { primary?: string };
  className?: string;
  label?: string;
}

export const Component: React.FC<ComponentProps> = ({
  min = 0,
  max = 100,
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  label
}) => {
  const [internalValue, setInternalValue] = useState<[number, number]>([25, 75]);
  const value = controlledValue || internalValue;
  const primary = theme.primary || '#14b8a6';
  
  const handleMinChange = (newMin: number) => {
    const newValue: [number, number] = [Math.min(newMin, value[1]), value[1]];
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  const handleMaxChange = (newMax: number) => {
    const newValue: [number, number] = [value[0], Math.max(newMax, value[0])];
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '440px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '25px', color: primary, fontSize: '17px', fontWeight: '800' }}>
          {label}
        </label>
      )}
      <div style={{ display: 'flex', gap: '19px', alignItems: 'center', marginBottom: '25px' }}>
        <span style={{ fontSize: '17px', color: '#6b7280', minWidth: '48px' }}> {value[0]}</span>
        <div style={{ flex: 1, height: '14px', backgroundColor: '#d1d5db', borderRadius: '31px', position: 'relative' }}>
          <div style={{
            position: 'absolute',
            left: `${(value[0] - min) / (max - min) * 100}%`,
            right: `${100 - (value[1] - min) / (max - min) * 100}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '31px'
          }} />
        </div>
        <span style={{ fontSize: '17px', color: '#6b7280', minWidth: '48px' }}> {value[1]}</span>
      </div>
      <div style={{ display: 'flex', gap: '19px' }}>
        <input
          type="range"
          min={min}
          max={max}
          value={value[0]}
          onChange={(e) => handleMinChange(Number(e.target.value))}
          style={{ flex: 1, accentColor: primary }}
        />
        <input
          type="range"
          min={min}
          max={max}
          value={value[1]}
          onChange={(e) => handleMaxChange(Number(e.target.value))}
          style={{ flex: 1, accentColor: primary }}
        />
      </div>
    </div>
  );
};