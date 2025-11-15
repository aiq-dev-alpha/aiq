import React, { useState } from 'react';

export interface ComponentProps {
  value?: string;
  onChange?: (color: string) => void;
  theme?: { primary?: string };
  className?: string;
  presetColors?: string[];
}

export const Component: React.FC<ComponentProps> = ({
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  presetColors = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6']
}) => {
  const [internalValue, setInternalValue] = useState('#3b82f6');
  const value = controlledValue || internalValue;
  const primary = theme.primary || '#3b82f6';
  
  const handleChange = (color: string) => {
    if (!controlledValue) setInternalValue(color);
    onChange?.(color);
  };
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '12px', maxWidth: '300px' }}>
      <input
        type="color"
        value={value}
        onChange={(e) => handleChange(e.target.value)}
        style={{
          width: '100%',
          height: '50px',
          border: `2px solid ${primary}`,
          borderRadius: '6px',
          cursor: 'pointer'
        }}
      />
      <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
        {presetColors.map((color, idx) => (
          <button
            key={idx}
            onClick={() => handleChange(color)}
            style={{
              width: '32px',
              height: '32px',
              backgroundColor: color,
              border: value === color ? `3px solid ${primary}` : 'none',
              borderRadius: '6px',
              cursor: 'pointer',
              transition: 'transform 0.2s'
            }}
            onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.1)'}
            onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1)'}
          />
        ))}
      </div>
    </div>
  );
};