import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);
  const primary = theme.primary || '#3b82f6';

  const handleClick = (e: React.MouseEvent) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const id = Date.now();
    setRipples([...ripples, { x, y, id }]);
    setTimeout(() => setRipples(r => r.filter(rip => rip.id !== id)), 800);
    onInteract?.('click');
  };

  return (
    <div className={className} onClick={handleClick} style={{ position: 'relative', padding: '18px 28px', background: primary, color: '#fff', borderRadius: '10px', cursor: 'pointer', overflow: 'hidden', fontWeight: 600 }}>
      {ripples.map(r => (
        <span key={r.id} style={{ position: 'absolute', left: r.x, top: r.y, width: '8px', height: '8px', borderRadius: '50%', background: 'rgba(255,255,255,0.6)', transform: 'translate(-50%, -50%)', animation: 'ripple 800ms ease-out' }} />
      ))}
      <span style={{ position: 'relative', zIndex: 1 }}>Ripple Effect Component</span>
      <style>{`@keyframes ripple { to { transform: translate(-50%, -50%) scale(30); opacity: 0; } }`}</style>
    </div>
  );
};