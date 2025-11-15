import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [rotation, setRotation] = useState(0);
  const primary = theme.primary || '#10b981';

  return (
    <button
      className={className}
      onClick={() => { setRotation(r => r + 90); onInteract?.('click'); }}
      style={{
        width: '48px',
        height: '48px',
        backgroundColor: primary,
        color: '#ffffff',
        border: 'none',
        borderRadius: '16px',
        fontSize: '20px',
        cursor: 'pointer',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        transform: `rotate(${rotation}deg)`,
        transition: 'transform 300ms ease'
      }}
    >
      ↻
    </button>
  );
};
