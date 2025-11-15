import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [flip, setFlip] = useState(false);
  const primary = theme.primary || '#10b981';
  
  return (
    <div style={{ perspective: '1000px', width: '300px', height: '200px' }} className={className}>
      <div
        onClick={() => { setFlip(!flip); onInteract?.('flip'); }}
        style={{
          width: '100%',
          height: '100%',
          position: 'relative',
          transformStyle: 'preserve-3d',
          transform: flip ? 'rotateY(180deg)' : 'rotateY(0)',
          transition: 'transform 600ms',
          cursor: 'pointer'
        }}
      >
        <div style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
          backfaceVisibility: 'hidden',
          background: primary,
          borderRadius: '16px',
          padding: '24px',
          color: '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '20px',
          fontWeight: 700
        }}>
          Front Side
        </div>
        <div style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
          backfaceVisibility: 'hidden',
          background: '#ffffff',
          border: `2px solid ${primary}`,
          borderRadius: '16px',
          padding: '24px',
          color: primary,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '20px',
          fontWeight: 700,
          transform: 'rotateY(180deg)'
        }}>
          Back Side
        </div>
      </div>
    </div>
  );
};