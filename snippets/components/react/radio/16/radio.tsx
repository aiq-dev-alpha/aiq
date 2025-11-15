import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({ count: 0, hover: false });
  const primary = theme.primary || '#d946ef';

  useEffect(() => {
    if (state.count > 0) {
      const timer = setTimeout(() => onInteract?.('auto'), 500);
      return () => clearTimeout(timer);
    }
  }, [state.count]);

  return (
    <div
      className={className}
      onClick={() => setState(s => ({ ...s, count: s.count + 1 }))}
      onMouseEnter={() => setState(s => ({ ...s, hover: true }))}
      onMouseLeave={() => setState(s => ({ ...s, hover: false }))}
      style={{
        padding: '16px 28px',
        background: state.hover ? `linear-gradient(135deg, ${primary}, ${primary}dd)` : primary,
        color: '#ffffff',
        borderRadius: '12px',
        cursor: 'pointer',
        fontSize: '15px',
        fontWeight: 600,
        boxShadow: state.hover ? '0 8px 20px rgba(0,0,0,0.2)' : '0 4px 12px rgba(0,0,0,0.15)',
        transform: state.hover ? 'translateY(-3px) scale(1.02)' : 'translateY(0) scale(1)',
        transition: 'all 250ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        position: 'relative',
        overflow: 'hidden'
      }}
    >
      <span style={{ position: 'relative', zIndex: 1 }}>Count: {state.count}</span>
      <div style={{
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: 'rgba(255,255,255,0.1)',
        transform: state.count % 2 === 0 ? 'translateX(-100%)' : 'translateX(100%)',
        transition: 'transform 300ms'
      }} />
    </div>
  );
};
