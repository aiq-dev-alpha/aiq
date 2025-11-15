import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [split, setSplit] = useState(false);
  const primary = theme.primary || '#ec4899';
  return (
    <div style={{ display: 'flex', gap: split ? '12px' : '0px', transition: 'gap 400ms' }}>
      <button className={className} onClick={() => { setSplit(!split); onInteract?.('split'); }}
        style={{ padding: '14px 24px', background: primary, color: '#fff', border: 'none',
          borderRadius: '8px 0 0 8px', fontSize: '16px', fontWeight: 700, cursor: 'pointer', outline: 'none' }}>
        Split
      </button>
      <button style={{ padding: '14px 24px', background: `${primary}cc`, color: '#fff', border: 'none',
        borderRadius: '0 8px 8px 0', fontSize: '16px', fontWeight: 700, cursor: 'pointer', outline: 'none' }}>
        Button
      </button>
    </div>
  );
};