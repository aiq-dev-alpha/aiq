import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState(false);
  const primary = theme.primary || '#f97316';
  
  return (
    <button
      className={className}
      onClick={() => { setState(!state); onInteract?.('confetti'); }}
      style={{
        padding: '14px 32px',
        background: primary,
        color: '#fff',
        border: 'none',
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 300ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        transform: state ? 'scale(1.05)' : 'scale(1)',
        outline: 'none'
      }}
    >
      Confetti
    </button>
  );
};