import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [particles, setParticles] = useState<{id: number, x: number, y: number}[]>([]);
  const primary = theme.primary || '#ef4444';

  const handleClick = (e: React.MouseEvent) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const newParticles = Array.from({ length: 8 }, (_, i) => ({
      id: Date.now() + i,
      x: e.clientX - rect.left,
      y: e.clientY - rect.top
    }));
    setParticles(newParticles);
    setTimeout(() => setParticles([]), 800);
    onInteract?.('burst');
  };

  return (
    <button
      className={className}
      onClick={handleClick}
      style={{
        position: 'relative',
        padding: '16px 40px',
        background: primary,
        color: '#fff',
        border: 'none',
        borderRadius: '8px',
        fontSize: '18px',
        fontWeight: 800,
        cursor: 'pointer',
        overflow: 'hidden',
        outline: 'none'
      }}
    >
      Burst Effect
      {particles.map((p, i) => (
        <div
          key={p.id}
          style={{
            position: 'absolute',
            left: p.x,
            top: p.y,
            width: '8px',
            height: '8px',
            borderRadius: '50%',
            background: '#fbbf24',
            transform: `translate(-50%, -50%) translate(${Math.cos(i * 45) * 60}px, ${Math.sin(i * 45) * 60}px)`,
            opacity: 0,
            transition: 'all 800ms cubic-bezier(0, 0.5, 0.5, 1)',
            pointerEvents: 'none'
          }}
        />
      ))}
    </button>
  );
};