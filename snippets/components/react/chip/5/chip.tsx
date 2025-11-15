import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  selected?: boolean;
  onSelect?: (selected: boolean) => void;
  onRemove?: () => void;
  removable?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Chip',
  selected: initialSelected = false,
  onSelect,
  onRemove,
  removable = true,
  theme = {},
  className = ''
}) => {
  const [selected, setSelected] = useState(initialSelected);
  const [isHovered, setIsHovered] = useState(false);
  const primary = theme.primary || '#ec4899';

  const handleClick = () => {
    if (!removable || isHovered) return;
    const newSelected = !selected;
    setSelected(newSelected);
    onSelect?.(newSelected);
  };

  const handleRemove = (e: React.MouseEvent) => {
    e.stopPropagation();
    onRemove?.();
  };

  return (
    <div
      className={className}
      onClick={handleClick}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        padding: removable ? '6px 12px 6px 14px' : '8px 16px',
        backgroundColor: selected ? primary : '#f3f4f6',
        color: selected ? '#fff' : '#374151',
        borderRadius: '20px',
        fontSize: '14px',
        fontWeight: '500',
        cursor: removable ? 'default' : 'pointer',
        transition: 'all 0.2s ease',
        boxShadow: selected ? `0 2px 8px ${primary}40` : '0 1px 3px rgba(0,0,0,0.1)',
        border: selected ? `1px solid ${primary}` : '1px solid #e5e7eb'
      }}
    >
      <span>{label}</span>
      {removable && (
        <button
          onMouseEnter={() => setIsHovered(true)}
          onMouseLeave={() => setIsHovered(false)}
          onClick={handleRemove}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            padding: '0',
            display: 'flex',
            alignItems: 'center',
            fontSize: '18px',
            lineHeight: '1',
            opacity: isHovered ? 1 : 0.6,
            transition: 'opacity 0.2s'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};