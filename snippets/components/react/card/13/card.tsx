// Variant 13: Blog post card with read time
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isBookmarked, setIsBookmarked] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateY(0)' : 'translateY(30px)',
        transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        overflow: 'hidden',
        boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.12)' : '0 6px 16px rgba(0,0,0,0.08)',
        cursor: 'pointer',
        width: '360px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ position: 'relative' as const, height: '200px', overflow: 'hidden' }}>
        <img
          src="https://images.unsplash.com/photo-1499750310107-5fef28a66643"
          alt="Blog post"
          style={{ width: '100%', height: '100%', objectFit: 'cover' as const, transition: 'transform 400ms ease', transform: isHovered ? 'scale(1.08)' : 'scale(1)' }}
        />
        <button
          onClick={(e) => { e.stopPropagation(); setIsBookmarked(!isBookmarked); }}
          style={{
            position: 'absolute' as const,
            top: '16px',
            right: '16px',
            width: '40px',
            height: '40px',
            borderRadius: '50%',
            border: 'none',
            backgroundColor: 'rgba(255,255,255,0.95)',
            cursor: 'pointer',
            fontSize: '20px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
          }}
        >
          {isBookmarked ? '🔖' : '📄'}
        </button>
      </div>
      <div style={{ padding: '24px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '12px' }}>
          <span style={{ padding: '4px 12px', backgroundColor: '#f3f4f6', borderRadius: '6px', fontSize: '12px', fontWeight: '600', color: theme.primary || '#3b82f6' }}>
            Development
          </span>
          <span style={{ fontSize: '13px', color: '#9ca3af' }}>• 8 min read</span>
        </div>
        <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '12px', lineHeight: '1.4' }}>
          10 Tips for Better Code Architecture
        </h3>
        <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.6', marginBottom: '16px' }}>
          Learn how to structure your codebase for maximum maintainability and scalability.
        </p>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <img
              src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"
              alt="Author"
              style={{ width: '32px', height: '32px', borderRadius: '50%', objectFit: 'cover' as const }}
            />
            <div>
              <div style={{ fontSize: '13px', fontWeight: '600', color: theme.text || '#111827' }}>John Developer</div>
              <div style={{ fontSize: '12px', color: '#9ca3af' }}>Nov 15, 2024</div>
            </div>
          </div>
          <button style={{
            padding: '8px 16px',
            borderRadius: '8px',
            border: `2px solid ${theme.primary || '#3b82f6'}`,
            backgroundColor: 'transparent',
            color: theme.primary || '#3b82f6',
            fontSize: '13px',
            fontWeight: '600',
            cursor: 'pointer',
            transition: 'all 200ms ease',
          }}>
            Read →
          </button>
        </div>
      </div>
    </div>
  );
};
