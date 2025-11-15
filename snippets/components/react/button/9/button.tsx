import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [hue, setHue] = useState(0);
  const primary = theme.primary || '#3b82f6';

  useEffect(() => {
    const interval = setInterval(() => setHue(h => (h + 1) % 360), 50);
    return () => clearInterval(interval);
  }, []);

  return (
    <button
      className={className}
      onClick={() => onInteract?.('rainbow')}
      style={{
        padding: '16px 32px',
        background: `linear-gradient(135deg, hsl(${hue}, 70%, 60%), hsl(${(hue + 60) % 360}, 70%, 60%))`,
        color: '#fff',
        border: 'none',
        borderRadius: '16px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        boxShadow: `0 4px 12px hsl(${hue}, 70%, 60%, 0.4)`,
        transition: 'box-shadow 200ms',
        outline: 'none'
      }}
    >
      Rainbow Button
    </button>
  );
};