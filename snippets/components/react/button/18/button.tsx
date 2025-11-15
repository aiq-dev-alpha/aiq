import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [skewed, setSkewed] = useState(false);
  const primary = theme.primary || '#f59e0b';
  return (
    <button className={className} onClick={() => { setSkewed(!skewed); onInteract?.('skew'); }}
      style={{ padding: '14px 32px', background: primary, color: '#fff', border: 'none',
        borderRadius: '8px', fontSize: '16px', fontWeight: 700, cursor: 'pointer',
        transform: skewed ? 'skewX(-10deg) scale(1.1)' : 'skewX(0) scale(1)',
        transition: 'transform 300ms', outline: 'none' }}>
      Skew Effect
    </button>
  );
};