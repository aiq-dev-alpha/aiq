import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const primary = theme.primary || '#8b5cf6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  return (
  <div
  className={className}
  onClick={() => { setActive(!active); onInteract?.('interact'); }}
  style={{
  padding: '16px 24px',
  backgroundColor: active ? primary : background,
  color: active ? '#ffffff' : text,
  border: `2px solid ${primary}`,
  borderRadius: '24px',
  cursor: 'pointer',
  fontSize: '15px',
  fontWeight: 500,
  transition: 'all 200ms ease',
  boxShadow: active ? '0 4px 12px rgba(0,0,0,0.15)' : '0 2px 6px rgba(0,0,0,0.08)'
  }}
  >
  Toggle Variant 5
  </div>
  );
};
