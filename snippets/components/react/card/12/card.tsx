// Variant 12: Testimonial card with quote styling
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
        transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '32px',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        borderLeft: `4px solid ${theme.primary || '#3b82f6'}`,
        boxShadow: isHovered ? '0 12px 28px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)',
        cursor: 'pointer',
        width: '380px',
        position: 'relative' as const,
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ fontSize: '64px', color: theme.primary || '#3b82f6', opacity: 0.2, lineHeight: '1', marginBottom: '-20px' }}>"</div>
      <p style={{ fontSize: '18px', color: theme.text || '#111827', lineHeight: '1.7', marginBottom: '24px', fontStyle: 'italic' }}>
        This product has completely transformed the way we work. The intuitive interface and powerful features have saved us countless hours.
      </p>
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <img
          src="https://images.unsplash.com/photo-1494790108377-be9c29b29330"
          alt="Sarah Mitchell"
          style={{ width: '56px', height: '56px', borderRadius: '50%', objectFit: 'cover' as const }}
        />
        <div>
          <div style={{ fontSize: '16px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>Sarah Mitchell</div>
          <div style={{ fontSize: '14px', color: '#6b7280' }}>CEO, TechCorp Inc.</div>
        </div>
      </div>
      <div style={{ display: 'flex', gap: '4px', marginTop: '16px' }}>
        {[1, 2, 3, 4, 5].map((star) => (
          <span key={star} style={{ color: '#fbbf24', fontSize: '20px' }}>★</span>
        ))}
      </div>
    </div>
  );
};
