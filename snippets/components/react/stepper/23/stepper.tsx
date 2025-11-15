import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [selected, setSelected] = useState(false);
  const primary = theme.primary || '#3b82f6';

  return (
    <div
      className={className}
      onClick={() => { setSelected(!selected); onInteract?.('select'); }}
      style={{
        padding: '18px 24px',
        backgroundColor: selected ? `${primary}15` : '#ffffff',
        border: `2px solid ${selected ? primary : '#e5e7eb'}`,
        borderRadius: '6px',
        cursor: 'pointer',
        transition: 'all 200ms ease',
        position: 'relative'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <div style={{
          width: '24px',
          height: '24px',
          borderRadius: '50%',
          border: `2px solid ${selected ? primary : '#d1d5db'}`,
          backgroundColor: selected ? primary : 'transparent',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          transition: 'all 200ms'
        }}>
          {selected && <div style={{ width: '10px', height: '10px', borderRadius: '50%', backgroundColor: '#fff' }} />}
        </div>
        <span style={{ fontSize: '15px', fontWeight: 500, color: selected ? primary : '#1f2937' }}>
          Option {idx}
        </span>
      </div>
    </div>
  );
};
