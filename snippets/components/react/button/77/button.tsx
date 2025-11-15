import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const primary = theme.primary || '#7c3aed';
  
  return (
    <button
      className={className}
      onClick={() => { setActive(!active); onInteract?.('overflow_hidden'); }}
      style={{
        padding: '14px 32px',
        background: active ? `linear-gradient(135deg, ${primary}, ${primary}dd)` : primary,
        color: '#fff',
        border: 'none',
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 300ms ease',
        boxShadow: active ? `0 8px 24px ${primary}60` : `0 2px 8px ${primary}40`,
        transform: active ? 'translateY(-4px)' : 'translateY(0)',
        outline: 'none'
      }}
    >
      Overflow Hidden
    </button>
  );
};