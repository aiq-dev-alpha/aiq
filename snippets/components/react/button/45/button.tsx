import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState(false);
  const primary = theme.primary || '#8b5cf6';
  
  return (
    <button
      className={className}
      onClick={() => { setState(!state); onInteract?.('flip_y'); }}
      style={{
        padding: '14px 32px',
        background: primary,
        color: '#fff',
        border: 'none',
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 350ms cubic-bezier(0.68, -0.55, 0.265, 1.55)',
        transform: 'rotateY(state ? 180deg : 0)',
        outline: 'none'
      }}
    >
      Flip Y
    </button>
  );
};