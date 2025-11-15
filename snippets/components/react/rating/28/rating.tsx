import React, { useState } from 'react';

export interface ComponentProps {
  value?: number;
  max?: number;
  onChange?: (value: number) => void;
  theme?: { primary?: string };
  className?: string;
  readonly?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  value: controlledValue,
  max = 5,
  onChange,
  theme = {},
  className = '',
  readonly = false
}) => {
  const [internalValue, setInternalValue] = useState(0);
  const [hoveredValue, setHoveredValue] = useState(0);
  const value = controlledValue !== undefined ? controlledValue : internalValue;
  const primary = theme.primary || '#f59e0b';
  
  const handleClick = (newValue: number) => {
    if (readonly) return;
    if (controlledValue === undefined) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div
      className={className}
      style={{ display: 'flex', gap: '2px', fontSize: '17px' }}
      onMouseLeave={() => !readonly && setHoveredValue(0)}
    >
      {Array.from({ length: max }, (_, i) => i + 1).map(star => (
        <span
          key={star}
          onClick={() => handleClick(star)}
          onMouseEnter={() => !readonly && setHoveredValue(star)}
          style={{
            cursor: readonly ? 'default' : 'pointer',
            color: star <= (hoveredValue || value) ? primary : '#d1d5db',
            transition: 'all 0.35s ease',
            transform: star === hoveredValue ? 'scale(1.15)' : 'scale(1.15)'
          }}
        >
          ★
        </span>
      ))}
    </div>
  );
};