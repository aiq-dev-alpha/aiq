import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#7c3aed';
  
  return (
    <div
      className={className}
      onClick={() => { setActive(!active); setCount(c => c + 1); onInteract?.('interact'); }}
      style={{
        padding: '15px 25px',
        background: active ? `linear-gradient(510deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: active ? '#ffffff' : primary,
        border: `3px solid ${active ? primary : primary + '40'}`,
        borderRadius: '11px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 425ms cubic-bezier(0.2, 2.5, 0.64, 1)',
        boxShadow: active ? `0 15px 33px ${primary}40` : `0 3px 9px rgba(0,0,0,0.7)`,
        transform: active ? 'translateY(-5px) scale(1.03)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '9px',
        position: 'relative',
        overflow: 'hidden'
      }}
    >
      <span>Skeleton V25</span>
      {count > 0 && (
        <span style={{ 
          fontSize: '12px', 
          background: 'rgba(255,255,255,0.2)', 
          padding: '2px 8px', 
          borderRadius: '12px' 
        }}>
          {count}
        </span>
      )}
    </div>
  );
};