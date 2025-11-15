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
  const primary = theme.primary || '#ef4444';
  
  const handleClick = (newValue: number) => {
    if (readonly) return;
    if (controlledValue === undefined) setInternalValue(newValue);
    onChange?.(newValue);
  };
  
  return (
    <div
      className={className}
      style={{ display: 'flex', gap: '15px', fontSize: '15px' }}
      onMouseLeave={() => !readonly && setHoveredValue(0)}
    >
      {Array.from({ length: max }, (_, i) => i + 1).map(star => (
        <span
          key={star}
          onClick={() => handleClick(star)}
          onMouseEnter={() => !readonly && setHoveredValue(star)}
          style={{
            cursor: readonly ? 'default' : 'pointer',
            color: star <= (hoveredValue || value) ? primary : '#e5e7eb',
            transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
            transform: star === hoveredValue ? 'scale(1.20)' : 'scale(1.20)'
          }}
        >
          ❤
        </span>
      ))}
    </div>
  );
};