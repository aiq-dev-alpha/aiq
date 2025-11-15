import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#06b6d4';
  
  return (
    <div
      className={className}
      onClick={() => { setActive(!active); setCount(c => c + 1); onInteract?.('interact'); }}
      style={{
        padding: '18px 26px',
        background: active ? `linear-gradient(285deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: active ? '#ffffff' : primary,
        border: `2px solid ${active ? primary : primary + '40'}`,
        borderRadius: '12px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 350ms cubic-bezier(0.2, 1.8, 0.64, 1)',
        boxShadow: active ? `0 10px 34px ${primary}40` : `0 4px 10px rgba(0,0,0,0.8)`,
        transform: active ? 'translateY(-6px) scale(1.03)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '10px',
        position: 'relative',
        overflow: 'hidden'
      }}
    >
      <span>Rating V10</span>
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