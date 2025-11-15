import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const primary = theme.primary || '#22c55e';
  
  return (
    <div
      className={className}
      onClick={() => { setActive(!active); onInteract?.('avatar'); }}
      style={{
        padding: '12px 20px',
        background: active ? primary : `${primary}20`,
        color: active ? '#ffffff' : primary,
        border: `2px solid ${active ? primary : primary + '40'}`,
        borderRadius: '9px',
        fontSize: '14px',
        fontWeight: 600,
        cursor: 'pointer',
        transition: 'all 280ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        display: 'inline-block',
        userSelect: 'none'
      }}
    >
      Avatar 8
    </div>
  );
};