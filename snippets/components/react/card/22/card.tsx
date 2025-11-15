// Variant 22: Interactive card (lifts on hover)
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  useEffect(() => { setIsVisible(true); }, []);

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    setMousePos({
      x: ((e.clientX - rect.left) / rect.width - 0.5) * 20,
      y: ((e.clientY - rect.top) / rect.height - 0.5) * 20,
    });
  };

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible
          ? isHovered
            ? `translateY(-16px) rotateX(${-mousePos.y}deg) rotateY(${mousePos.x}deg)`
            : 'translateY(0) rotateX(0deg) rotateY(0deg)'
          : 'scale(0.9)',
        transition: 'opacity 300ms ease, transform 150ms ease',
        padding: '32px',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
        borderRadius: '20px',
        boxShadow: isHovered ? '0 24px 48px rgba(59,130,246,0.4)' : '0 8px 16px rgba(59,130,246,0.2)',
        cursor: 'pointer',
        width: '300px',
        transformStyle: 'preserve-3d' as const,
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); setMousePos({ x: 0, y: 0 }); onHover?.(false); }}
      onMouseMove={handleMouseMove}
    >
      <div style={{ transform: 'translateZ(40px)', transition: 'transform 150ms ease' }}>
        <h3 style={{ fontSize: '28px', fontWeight: 'bold', color: '#ffffff', marginBottom: '12px' }}>
          Interactive 3D
        </h3>
        <p style={{ fontSize: '16px', color: 'rgba(255,255,255,0.9)', lineHeight: '1.6' }}>
          Move your mouse over this card to see the interactive 3D effect in action.
        </p>
      </div>
    </div>
  );
};
