import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#3b82f6';
  
  return (
    <div
      className={className}
      onClick={() => { setActive(!active); setCount(c => c + 1); onInteract?.('interact'); }}
      style={{
        padding: '16px 28px',
        background: active ? `linear-gradient(435deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: active ? '#ffffff' : primary,
        border: `2px solid ${active ? primary : primary + '40'}`,
        borderRadius: '14px',
        fontSize: '17px',
        fontWeight: 800,
        cursor: 'pointer',
        transition: 'all 400ms cubic-bezier(0.2, 1.6, 0.64, 1)',
        boxShadow: active ? `0 10px 28px ${primary}40` : `0 2px 12px rgba(0,0,0,0.6)`,
        transform: active ? 'translateY(-4px) scale(1.04)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        position: 'relative',
        overflow: 'hidden'
      }}
    >
      <span>Popover V20</span>
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