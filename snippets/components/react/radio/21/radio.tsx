import React, { useState } from 'react';

interface RadioOption {
  label: string;
  value: string;
}

export interface ComponentProps {
  options?: RadioOption[];
  value?: string;
  onChange?: (value: string) => void;
  theme?: { primary?: string };
  className?: string;
  disabled?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  options = [
    { label: 'Option 1', value: '1' },
    { label: 'Option 2', value: '2' },
    { label: 'Option 3', value: '3' }
  ],
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  disabled = false
}) => {
  const [internalValue, setInternalValue] = useState('');
  const value = controlledValue || internalValue;
  const primary = theme.primary || '#0ea5e9';
  
  const handleChange = (newValue: string) => {
    if (disabled) return;
    if (!controlledValue) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
      {options.map((option) => {
        const isSelected = value === option.value;
        return (
          <label
            key={option.value}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '2px',
              cursor: disabled ? 'not-allowed' : 'pointer',
              opacity: disabled ? 0.5 : 1
            }}
          >
            <div
              onClick={() => handleChange(option.value)}
              style={{
                width: '20px',
                height: '20px',
                borderRadius: '50%',
                border: `2px solid ${isSelected ? primary : '#d1d5db'}`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                transition: 'all 0.15s ease',
                boxShadow: isSelected ? '0 0 0 3px rgba(59,130,246,0.2)' : 'none'
              }}
            >
              {isSelected && (
                <div
                  style={{
                    width: '10px',
                    height: '10px',
                    borderRadius: '50%',
                    backgroundColor: primary
                  }}
                />
              )}
            </div>
            <span style={{ fontSize: '11px', color: '#374151', fontWeight: '300' }}>
              {option.label}
            </span>
          </label>
        );
      })}
    </div>
  );
};