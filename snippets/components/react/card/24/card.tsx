// Variant 24: Gradient border card
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
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
        padding: isHovered ? '3px' : '2px',
        borderRadius: '20px',
        cursor: 'pointer',
        width: '320px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '18px',
        padding: '32px',
        height: '100%',
      }}>
        <h3 style={{ fontSize: '24px', fontWeight: 'bold', marginBottom: '12px', background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
          Gradient Border
        </h3>
        <p style={{ fontSize: '15px', color: '#6b7280', lineHeight: '1.6', marginBottom: '20px' }}>
          A stunning card with animated gradient border that catches the eye.
        </p>
        <div style={{ fontSize: '13px', color: '#9ca3af' }}>
          Hover to see the effect intensify
        </div>
      </div>
    </div>
  );
};
