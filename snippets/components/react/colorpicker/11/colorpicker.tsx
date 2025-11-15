import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState(false);
  const [hovered, setHovered] = useState(false);
  const primary = theme.primary || '#f97316';
  const bg = theme.background || '#ffffff';
  
  return (
    <div
      className={className}
      onClick={() => { setState(!state); onInteract?.('colorpicker_click'); }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      style={{
        padding: '18px 29px',
        background: state ? primary : bg,
        color: state ? '#ffffff' : primary,
        border: `2px solid ${hovered ? primary : primary + '50'}`,
        borderRadius: '11px',
        fontSize: '17px',
        fontWeight: 800,
        cursor: 'pointer',
        transition: 'all 360ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        transform: hovered ? 'translateY(-5px) scale(1.42)' : 'translateY(0) scale(1)',
        boxShadow: hovered ? `0 11px 27px ${primary}41` : '0 2px 8px rgba(0,0,0,0.08)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        userSelect: 'none'
      }}
    >
      <span>Colorpicker 11</span>
      {state && <span style={{ fontSize: '12px', opacity: 0.9 }}>✓</span>}
    </div>
  );
};