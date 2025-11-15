import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [isPressed, setIsPressed] = useState(false);
  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  return (
  <button
  className={className}
  onMouseDown={() => setIsPressed(true)}
  onMouseUp={() => setIsPressed(false)}
  onMouseLeave={() => setIsPressed(false)}
  onClick={() => onInteract?.('click')}
  style={{
  padding: '12px 28px',
  backgroundColor: 'transparent',
  color: primary,
  border: `2px solid ${primary}`,
  borderRadius: '24px',
  fontSize: '15px',
  fontWeight: 600,
  cursor: 'pointer',
  transform: isPressed ? 'scale(0.95)' : 'scale(1)',
  transition: 'all 150ms ease',
  outline: 'none'
  }}
  >
  Outlined Button
  </button>
  );
};
