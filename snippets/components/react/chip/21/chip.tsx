import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  selected?: boolean;
  onToggle?: (selected: boolean) => void;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Choice',
  selected: initialSelected = false,
  onToggle,
  theme = {},
  className = ''
}) => {
  const [selected, setSelected] = useState(initialSelected);
  const primary = theme.primary || '#8b5cf6';

  const handleClick = () => {
    const newSelected = !selected;
    setSelected(newSelected);
    onToggle?.(newSelected);
  };

  return (
    <button
      className={className}
      onClick={handleClick}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        padding: '8px 16px',
        backgroundColor: selected ? primary : '#fff',
        color: selected ? '#fff' : '#374151',
        border: selected ? 'none' : '1px solid #d1d5db',
        borderRadius: '24px',
        fontSize: '14px',
        fontWeight: '500',
        cursor: 'pointer',
        transition: 'all 0.2s',
        boxShadow: selected ? '0 2px 8px rgba(0,0,0,0.15)' : 'none'
      }}
    >
      {selected && <span style={{ fontSize: '16px' }}>✓</span>}
      <span>{label}</span>
    </button>
  );
};