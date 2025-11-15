import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [layers, setLayers] = useState(0);
  const primary = theme.primary || '#06b6d4';

  return (
    <div style={{ position: 'relative', display: 'inline-block' }}>
      {Array.from({ length: layers }).map((_, i) => (
        <div
          key={i}
          style={{
            position: 'absolute',
            inset: `-${(i + 1) * 3}px`,
            background: primary,
            borderRadius: '12px',
            opacity: 0.2 - i * 0.05,
            zIndex: -i - 1,
            transition: 'all 300ms'
          }}
        />
      ))}
      <button
        className={className}
        onClick={() => { setLayers(l => (l + 1) % 5); onInteract?.('layer'); }}
        style={{
          position: 'relative',
          padding: '14px 30px',
          background: primary,
          color: '#fff',
          border: 'none',
          borderRadius: '12px',
          fontSize: '16px',
          fontWeight: 600,
          cursor: 'pointer',
          zIndex: 1,
          outline: 'none'
        }}
      >
        Layered: {layers}
      </button>
    </div>
  );
};