import React, { useState } from 'react';

export interface RadioOption {
  value: string;
  label: string;
  description?: string;
}

export interface ComponentProps {
  options?: RadioOption[];
  value?: string;
  onChange?: (value: string) => void;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  options = [
  { value: '1', label: 'Option 1', description: 'First choice' },
  { value: '2', label: 'Option 2', description: 'Second choice' },
  { value: '3', label: 'Option 3', description: 'Third choice' }
  ],
  value: controlledValue,
  onChange,
  theme = {},
  className = ''
}) => {
  const [internalValue, setInternalValue] = useState(controlledValue || options[0]?.value);
  const primary = theme.primary || '#ef4444';
  const selectedValue = controlledValue !== undefined ? controlledValue : internalValue;

  const handleChange = (newValue: string) => {
  setInternalValue(newValue);
  onChange?.(newValue);
  };

  return (
  <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
  {options.map((option) => {
  const isSelected = selectedValue === option.value;
  return (
  <label
  key={option.value}
  style={{
  display: 'flex',
  alignItems: 'center',
  gap: '12px',
  padding: '12px',
  borderRadius: '8px',
  border: `2px solid ${isSelected ? primary : '#e5e7eb'}`,
  backgroundColor: isSelected ? `${primary}10` : '#fff',
  cursor: 'pointer',
  transition: 'all 0.2s ease'
  }}
  >
  <input
  type="radio"
  value={option.value}
  checked={isSelected}
  onChange={(e) => handleChange(e.target.value)}
  style={{ display: 'none' }}
  />
  <div
  style={{
  width: '20px',
  height: '20px',
  borderRadius: '50%',
  border: `2px solid ${isSelected ? primary : '#d1d5db'}`,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  flexShrink: 0
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
  <div style={{ flex: 1 }}>
  <div style={{ fontWeight: '500', fontSize: '15px', color: '#1f2937' }}>
  {option.label}
  </div>
  {option.description && (
  <div style={{ fontSize: '13px', color: '#6b7280', marginTop: '2px' }}>
  {option.description}
  </div>
  )}
  </div>
  </label>
  );
  })}
  </div>
  );
};
