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
  const primary = theme.primary || '#ef4444';
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = Number(e.target.value);
    if (controlledValue === undefined) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  const percentage = ((value - min) / (max - min)) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '420px' }}>
      {(label || showValue) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '17px', fontSize: '22px' }}>
          {label && <span style={{ color: '#374151', fontWeight: '800' }}> {label}</span>}
          {showValue && (
            <span style={{ color: primary, fontWeight: '800', fontSize: '22px' }}>
              {value}
            </span>
          )}
        </div>
      )}
      <div style={{ position: 'relative', height: '15px' }}>
        <div style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
          backgroundColor: '#d1d5db',
          borderRadius: '27px',
          overflow: 'hidden'
        }}>
          <div style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '27px',
            transition: 'width 0.25s ease'
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
            opacity: 0.6,
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
          width: '29px',
          height: '29px',
          backgroundColor: primary,
          borderRadius: '50%',
          border: '3px solid #fff',
          boxShadow: '0 2px 9px rgba(0,0,0,0.06)',
          pointerEvents: 'none'
        }} />
      </div>
    </div>
  );
};