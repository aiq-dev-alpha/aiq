import React, { useState } from 'react';

export interface ComponentProps {
  min?: number;
  max?: number;
  value?: number;
  onChange?: (value: number) => void;
  theme?: { primary?: string };
  className?: string;
  label?: string;
  showValue?: boolean;
  step?: number;
}

export const Component: React.FC<ComponentProps> = ({
  min = 0,
  max = 100,
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  label,
  showValue = true,
  step = 1
}) => {
  const [internalValue, setInternalValue] = useState(50);
  const value = controlledValue !== undefined ? controlledValue : internalValue;
  const primary = theme.primary || '#ec4899';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = Number(e.target.value);
    if (controlledValue === undefined) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  const percentage = ((value - min) / (max - min)) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '410px' }}>
      {(label || showValue) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '13px', fontSize: '21px' }}>
          {label && <span style={{ color: '#374151', fontWeight: '600' }}> {label}</span>}
          {showValue && (
            <span style={{ color: primary, fontWeight: '600', fontSize: '21px' }}>
              {value}
            </span>
          )}
        </div>
      )}
      <div style={{ position: 'relative', height: '9px' }}>
        <div style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
          backgroundColor: '#e5e7eb',
          borderRadius: '13px',
          overflow: 'hidden'
        }}>
          <div style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '13px',
            transition: 'width 0.2s ease'
          }} />
        </div>
        <input
          type="range"
          min={min}
          max={max}
          step={step}
          value={value}
          onChange={handleChange}
          style={{
            position: 'absolute',
            width: '100%',
            height: '100%',
            opacity: 0.5,
            cursor: 'pointer',
            top: 0,
            left: 0
          }}
        />
        <div style={{
          position: 'absolute',
          left: `${percentage}%`,
          top: '50%',
          transform: 'translate(-50%, -50%)',
          width: '21px',
          height: '21px',
          backgroundColor: primary,
          borderRadius: '50%',
          border: '2px solid #fff',
          boxShadow: '0 2px 11px rgba(0,0,0,0.12)',
          pointerEvents: 'none'
        }} />
      </div>
    </div>
  );
};