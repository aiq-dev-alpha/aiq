import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [pressed, setPressed] = useState(false);
  const primary = theme.primary || '#a855f7';
  const bg = theme.background || '#ffffff';

  return (
  <button
  className={className}
  onMouseDown={() => setPressed(true)}
  onMouseUp={() => setPressed(false)}
  onMouseLeave={() => setPressed(false)}
  onClick={() => onInteract?.('click')}
  style={{
  padding: '14px 32px',
  backgroundColor: 'transparent',
  color: primary,
  border: `3px solid ${primary}`,
  borderRadius: '16px',
  cursor: 'pointer',
  fontSize: '16px',
  fontWeight: 700,
  transform: pressed ? 'scale(0.94)' : 'scale(1)',
  boxShadow: pressed ? 'inset 0 4px 8px rgba(0,0,0,0.2)' : 'none',
  transition: 'all 120ms ease',
  letterSpacing: '0.5px',
  textTransform: 'uppercase',
  outline: 'none'
  }}
  >
  Press Me
  </button>
  );
};
