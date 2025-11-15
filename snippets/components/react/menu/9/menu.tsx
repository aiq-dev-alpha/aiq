import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState(false);
  const [hovered, setHovered] = useState(false);
  const primary = theme.primary || '#a855f7';
  const bg = theme.background || '#ffffff';
  
  return (
    <div
      className={className}
      onClick={() => { setState(!state); onInteract?.('menu_click'); }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        padding: '14px 23px',
        background: state ? primary : bg,
        color: state ? '#ffffff' : primary,
        border: `2px solid ${hovered ? primary : primary + '50'}`,
        borderRadius: '9px',
        fontSize: '15px',
        fontWeight: 600,
        cursor: 'pointer',
        transition: 'all 340ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        transform: hovered ? 'translateY(-3px) scale(1.22)' : 'translateY(0) scale(1)',
        boxShadow: hovered ? `0 9px 25px ${primary}39` : '0 2px 8px rgba(0,0,0,0.08)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        userSelect: 'none'
      }}
    >
      <span>Menu 9</span>
      {state && <span style={{ fontSize: '12px', opacity: 0.9 }}>✓</span>}
    </div>
  );
};