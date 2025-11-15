// Variant 21: Feature card with icon
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
        transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '32px',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        border: `2px solid ${isHovered ? (theme.primary || '#3b82f6') : '#f3f4f6'}`,
        boxShadow: isHovered ? `0 12px 24px ${theme.primary || '#3b82f6'}20` : '0 4px 12px rgba(0,0,0,0.05)',
        cursor: 'pointer',
        width: '280px',
        textAlign: 'center' as const,
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{
        width: '80px',
        height: '80px',
        margin: '0 auto 20px',
        borderRadius: '20px',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}15, ${theme.primary || '#3b82f6'}05)`,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '40px',
        transition: 'transform 300ms ease',
        transform: isHovered ? 'scale(1.1) rotate(5deg)' : 'scale(1)',
      }}>
        ⚡
      </div>
      <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '12px' }}>
        Lightning Fast
      </h3>
      <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.6' }}>
        Experience blazing fast performance with optimized code and efficient algorithms.
      </p>
    </div>
  );
};
