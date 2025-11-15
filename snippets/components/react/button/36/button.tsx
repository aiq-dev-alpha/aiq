import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#84cc16';
  return (
  <div className={className} onClick={() => { setCount(c => c + 1); onInteract?.('click'); }} style={{ padding: '16px 24px', background: `linear-gradient(135deg, ${primary}, ${primary}cc)`, color: '#fff', borderRadius: '32px', cursor: 'pointer', fontSize: '15px', fontWeight: 600, boxShadow: '0 4px 12px rgba(0,0,0,0.15)', transition: 'transform 150ms', transform: count > 0 ? 'scale(0.98)' : 'scale(1)' }}>
  Clicks: {count}
  </div>
  );
};
