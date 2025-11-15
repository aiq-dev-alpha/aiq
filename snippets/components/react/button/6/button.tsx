import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#10b981';

  return (
    <button
      className={className}
      onClick={() => { setCount(c => c + 1); onInteract?.('increment'); }}
      style={{
        padding: '12px 24px',
        background: `conic-gradient(from ${count * 36}deg, ${primary}, #34d399, ${primary})`,
        color: '#fff',
        border: 'none',
        borderRadius: '12px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'transform 200ms',
        outline: 'none'
      }}
      onMouseDown={(e) => (e.currentTarget.style.transform = 'scale(0.95)')}
      onMouseUp={(e) => (e.currentTarget.style.transform = 'scale(1)')}
    >
      Clicks: {count}
    </button>
  );
};