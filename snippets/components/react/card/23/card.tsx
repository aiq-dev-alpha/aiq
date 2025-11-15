// Variant 23: Minimal card (clean, simple)
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
        transform: isVisible ? 'translateY(0)' : 'translateY(10px)',
        transition: 'all 250ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '40px',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '8px',
        border: `1px solid ${isHovered ? (theme.text || '#111827') : '#f3f4f6'}`,
        cursor: 'pointer',
        width: '300px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <h3 style={{
        fontSize: '14px',
        fontWeight: '500',
        color: theme.primary || '#3b82f6',
        marginBottom: '8px',
        textTransform: 'uppercase' as const,
        letterSpacing: '2px',
      }}>
        Minimalist
      </h3>
      <h2 style={{ fontSize: '24px', fontWeight: 'normal', color: theme.text || '#111827', marginBottom: '16px', lineHeight: '1.4' }}>
        Less is More
      </h2>
      <p style={{ fontSize: '15px', color: '#6b7280', lineHeight: '1.7' }}>
        Clean, simple design that focuses on content and clarity.
      </p>
    </div>
  );
};
