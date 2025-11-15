import React, { useState } from 'react';

export interface ComponentProps {
  items?: Array<{ id: string; label: string }>;
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (id: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  items = [{ id: '1', label: 'Item 1' }, { id: '2', label: 'Item 2' }, { id: '3', label: 'Item 3' }],
  theme = {},
  className = '',
  onInteract
}) => {
  const [selected, setSelected] = useState<string | null>(null);
  const primary = theme.primary || '#8b5cf6';

  return (
    <div className={className} style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
      {items.map(item => (
        <button
          key={item.id}
          onClick={() => { setSelected(item.id); onInteract?.(item.id); }}
          style={{
            padding: '10px 20px',
            background: selected === item.id ? primary : 'transparent',
            color: selected === item.id ? '#fff' : primary,
            border: `2px solid ${primary}`,
            borderRadius: '20px',
            cursor: 'pointer',
            fontWeight: 600,
            transition: 'all 200ms ease',
            transform: selected === item.id ? 'scale(1.05)' : 'scale(1)'
          }}
        >
          {item.label}
        </button>
      ))}
    </div>
  );
};