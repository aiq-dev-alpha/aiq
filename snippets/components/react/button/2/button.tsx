import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: {
  primary?: string;
  background?: string;
  text?: string;
  };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  theme = {},
  className = '',
  onInteract
}) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);
  const [pressed, setPressed] = useState(false);

  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  useEffect(() => {
  if (ripples.length > 0) {
  const timer = setTimeout(() => setRipples([]), 600);
  return () => clearTimeout(timer);
  }
  }, [ripples]);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  const rect = e.currentTarget.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;
  setRipples([...ripples, { x, y, id: Date.now() }]);
  setPressed(true);
  setTimeout(() => setPressed(false), 150);
  onInteract?.('click');
  };

  return (
  <button
  className={className}
  onClick={handleClick}
  style={{
  position: 'relative',
  padding: '12px 28px',
  backgroundColor: background,
  color: text,
  border: `2px solid ${primary}`,
  borderRadius: '8px',
  fontSize: '16px',
  fontWeight: 600,
  cursor: 'pointer',
  overflow: 'hidden',
  transform: pressed ? 'scale(0.96)' : 'scale(1)',
  transition: 'transform 150ms cubic-bezier(0.4, 0, 0.2, 1)',
  outline: 'none'
  }}
  >
  <span style={{ position: 'relative', zIndex: 1 }}>Ripple Button</span>
  {ripples.map(ripple => (
  <span
  key={ripple.id}
  style={{
  position: 'absolute',
  left: ripple.x,
  top: ripple.y,
  width: '10px',
  height: '10px',
  borderRadius: '50%',
  backgroundColor: `${primary}40`,
  transform: 'translate(-50%, -50%)',
  animation: 'ripple 600ms ease-out',
  pointerEvents: 'none'
  }}
  />
  ))}
  <style>{`
  @keyframes ripple {
  to {
  transform: translate(-50%, -50%) scale(30);
  opacity: 0;
  }
  }
  `}</style>
  </button>
  );
};