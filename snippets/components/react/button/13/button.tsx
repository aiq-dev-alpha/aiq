import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [flip, setFlip] = useState(false);
  const primary = theme.primary || '#6366f1';
  const secondary = theme.background || '#e0e7ff';

  return (
    <div style={{ perspective: '1000px', display: 'inline-block' }} className={className}>
      <button
        onClick={() => { setFlip(!flip); onInteract?.('flip'); }}
        style={{
          width: '160px',
          height: '60px',
          background: flip ? secondary : primary,
          color: flip ? primary : '#fff',
          border: `2px solid ${primary}`,
          borderRadius: '12px',
          fontSize: '16px',
          fontWeight: 600,
          cursor: 'pointer',
          transform: flip ? 'rotateY(180deg)' : 'rotateY(0)',
          transition: 'transform 600ms',
          transformStyle: 'preserve-3d',
          outline: 'none'
        }}
      >
        <div style={{ transform: flip ? 'rotateY(180deg)' : 'rotateY(0)' }}>
          {flip ? 'Flipped!' : 'Flip Me'}
        </div>
      </button>
    </div>
  );
};