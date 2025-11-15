import React, { useState } from 'react';

export interface ComponentProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  theme = {},
  className = '',
  onInteract
}) => {
  const [glowIntensity, setGlowIntensity] = useState(0);

  const primary = theme.primary || '#ec4899';
  const background = theme.background || '#1f2937';
  const text = theme.text || '#ffffff';

  return (
    <button
      className={className}
      onClick={() => onInteract?.('neon')}
      onMouseEnter={() => setGlowIntensity(1)}
      onMouseLeave={() => setGlowIntensity(0)}
      style={{
        padding: '14px 32px',
        background: background,
        color: primary,
        border: `2px solid ${primary}`,
        borderRadius: '6px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        textTransform: 'uppercase',
        letterSpacing: '2px',
        boxShadow: glowIntensity
          ? `0 0 10px ${primary}, 0 0 20px ${primary}, 0 0 40px ${primary}, inset 0 0 10px ${primary}40`
          : `0 0 5px ${primary}80, inset 0 0 5px ${primary}20`,
        transition: 'all 300ms ease',
        outline: 'none',
        textShadow: glowIntensity ? `0 0 10px ${primary}` : 'none'
      }}
    >
      Neon Glow
    </button>
  );
};