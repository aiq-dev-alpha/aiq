import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  label?: string;
  loading?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onClick?: () => void;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Click Me',
  loading = false,
  icon,
  iconPosition = 'left',
  theme = {},
  className = '',
  onClick
}) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);

  const primary = theme.primary || '#10b981';
  const text = theme.text || '#ffffff';

  useEffect(() => {
  if (ripples.length > 0) {
  const timer = setTimeout(() => setRipples([]), 600);
  return () => clearTimeout(timer);
  }
  }, [ripples]);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  if (!loading) {
  const rect = e.currentTarget.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;
  setRipples([...ripples, { x, y, id: Date.now() }]);
  onClick?.();
  }
  };

  return (
  <button
  className={className}
  onClick={handleClick}
  disabled={loading}
  style={{
  position: 'relative',
  padding: '12px 32px',
  backgroundColor: primary,
  color: text,
  border: 'none',
  borderRadius: '12px',
  fontSize: '16px',
  fontWeight: 600,
  cursor: loading ? 'wait' : 'pointer',
  overflow: 'hidden',
  display: 'flex',
  alignItems: 'center',
  gap: '8px',
  flexDirection: iconPosition === 'right' ? 'row-reverse' : 'row',
  transition: 'transform 100ms',
  outline: 'none'
  }}
  >
  {loading ? (
  <div style={{ width: '20px', height: '20px', border: '3px solid #ffffff50', borderTopColor: '#ffffff', borderRadius: '50%', animation: 'spin 600ms linear infinite' }} />
  ) : icon}
  <span style={{ position: 'relative', zIndex: 1 }}>{label}</span>
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
  backgroundColor: '#ffffff50',
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
  @keyframes spin {
  to { transform: rotate(360deg); }
  }
  `}</style>
  </button>
  );
};