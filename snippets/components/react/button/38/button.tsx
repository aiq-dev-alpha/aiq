import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const primary = theme.primary || '#14b8a6';
  return (
  <button className={className} onClick={() => { setActive(!active); onInteract?.('toggle'); }} style={{ padding: '12px 24px', backgroundColor: active ? primary : '#f3f4f6', color: active ? '#fff' : '#1f2937', border: 'none', borderRadius: '4px', cursor: 'pointer', fontSize: '14px', fontWeight: 600, transition: 'all 200ms', boxShadow: active ? `0 0 0 3px ${primary}40` : 'none' }}>
  {active ? 'Active' : 'Inactive'}
  </button>
  );
};
