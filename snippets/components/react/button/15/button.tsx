import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [progress, setProgress] = useState(0);
  const primary = theme.primary || '#a855f7';

  const handleClick = () => {
    setProgress(0);
    const interval = setInterval(() => {
      setProgress(p => {
        if (p >= 100) {
          clearInterval(interval);
          return 100;
        }
        return p + 5;
      });
    }, 30);
    onInteract?.('progress');
  };

  return (
    <button
      className={className}
      onClick={handleClick}
      style={{
        position: 'relative',
        padding: '14px 32px',
        background: '#fff',
        color: primary,
        border: `2px solid ${primary}`,
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        overflow: 'hidden',
        outline: 'none'
      }}
    >
      <div style={{
        position: 'absolute',
        left: 0,
        top: 0,
        height: '100%',
        width: `${progress}%`,
        background: `${primary}30`,
        transition: 'width 100ms linear',
        pointerEvents: 'none'
      }} />
      <span style={{ position: 'relative', zIndex: 1 }}>
        {progress === 100 ? 'Complete!' : 'Progress Button'}
      </span>
    </button>
  );
};