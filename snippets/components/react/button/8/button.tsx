import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [angle, setAngle] = useState(0);
  const primary = theme.primary || '#8b5cf6';

  return (
  <button
  className={className}
  onClick={() => { setAngle(a => a + 15); onInteract?.('rotate'); }}
  style={{
  padding: '14px 28px',
  background: `linear-gradient(${angle}deg, ${primary}, #a78bfa, ${primary})`,
  backgroundSize: '200% 200%',
  color: '#fff',
  border: 'none',
  borderRadius: '10px',
  fontSize: '15px',
  fontWeight: 600,
  cursor: 'pointer',
  transform: `rotate(${angle}deg)`,
  transition: 'transform 600ms cubic-bezier(0.68, -0.55, 0.265, 1.55)',
  outline: 'none'
  }}
  >
  Spinning Button
  </button>
  );
};