// Variant 7: Glassmorphism card with blur
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.9)',
        transition: 'all 400ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '32px',
        background: isHovered ? 'rgba(255, 255, 255, 0.25)' : 'rgba(255, 255, 255, 0.15)',
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        borderRadius: '24px',
        border: '1px solid rgba(255, 255, 255, 0.3)',
        boxShadow: isHovered
          ? '0 20px 50px rgba(0, 0, 0, 0.2), inset 0 0 40px rgba(255, 255, 255, 0.1)'
          : '0 8px 32px rgba(0, 0, 0, 0.12), inset 0 0 20px rgba(255, 255, 255, 0.05)',
        cursor: 'pointer',
        width: '320px',
        position: 'relative' as const,
        overflow: 'hidden',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{
        position: 'absolute' as const,
        top: '-50%',
        left: '-50%',
        width: '200%',
        height: '200%',
        background: `radial-gradient(circle, ${theme.primary || '#3b82f6'}33 0%, transparent 70%)`,
        opacity: isHovered ? 0.6 : 0,
        transition: 'opacity 400ms ease',
        pointerEvents: 'none' as const,
      }} />
      <h3 style={{ fontSize: '28px', fontWeight: 'bold', color: '#ffffff', marginBottom: '16px', textShadow: '0 2px 10px rgba(0, 0, 0, 0.3)' }}>
        Glassmorphism
      </h3>
      <p style={{ fontSize: '15px', color: 'rgba(255, 255, 255, 0.9)', lineHeight: '1.7', marginBottom: '24px' }}>
        A modern design trend featuring frosted glass aesthetics with blur effects and translucent layers.
      </p>
      <div style={{ display: 'flex', gap: '24px', marginBottom: '24px' }}>
        {[{ value: '2.4K', label: 'Followers' }, { value: '89', label: 'Projects' }, { value: '4.8', label: 'Rating' }].map((stat, i) => (
          <div key={i} style={{ flex: 1 }}>
            <div style={{ fontSize: '24px', fontWeight: 'bold', color: '#ffffff', marginBottom: '4px' }}>{stat.value}</div>
            <div style={{ fontSize: '12px', color: 'rgba(255, 255, 255, 0.7)', textTransform: 'uppercase' as const, letterSpacing: '1px' }}>{stat.label}</div>
          </div>
        ))}
      </div>
      <button style={{
        width: '100%',
        padding: '14px',
        borderRadius: '12px',
        border: '2px solid rgba(255, 255, 255, 0.5)',
        backgroundColor: 'rgba(255, 255, 255, 0.1)',
        color: '#ffffff',
        fontSize: '15px',
        fontWeight: '600',
        cursor: 'pointer',
        backdropFilter: 'blur(10px)',
        transform: isHovered ? 'translateY(-2px)' : 'translateY(0)',
        transition: 'all 300ms ease',
      }}>
        Explore More
      </button>
    </div>
  );
};
