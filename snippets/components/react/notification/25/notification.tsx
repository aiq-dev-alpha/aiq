import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState(false);
  const [hovered, setHovered] = useState(false);
  const primary = theme.primary || '#06b6d4';
  const bg = theme.background || '#ffffff';
  
  return (
    <div
      className={className}
      onClick={() => { setState(!state); onInteract?.('notification_click'); }}
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
        transition: 'all 500ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        transform: hovered ? 'translateY(-3px) scale(1.32)' : 'translateY(0) scale(1)',
        boxShadow: hovered ? `0 9px 17px ${primary}35` : '0 2px 8px rgba(0,0,0,0.08)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        userSelect: 'none'
      }}
    >
      <span>Notification 25</span>
      {state && <span style={{ fontSize: '12px', opacity: 0.9 }}>✓</span>}
    </div>
  );
};