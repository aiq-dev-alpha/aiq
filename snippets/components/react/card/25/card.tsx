// Variant 25: Image gallery card (multiple images)
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [activeImg, setActiveImg] = useState(0);

  useEffect(() => { setIsVisible(true); }, []);

  const images = [
    'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba',
    'https://images.unsplash.com/photo-1682687221038-404cb8830901',
    'https://images.unsplash.com/photo-1682687220063-4742bd7fd538',
  ];

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        overflow: 'hidden',
        boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)',
        cursor: 'pointer',
        width: '340px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ position: 'relative' as const, height: '240px', backgroundColor: '#f3f4f6' }}>
        {images.map((img, i) => (
          <img
            key={i}
            src={img}
            alt={`Gallery ${i + 1}`}
            style={{
              position: 'absolute' as const,
              top: 0,
              left: 0,
              width: '100%',
              height: '100%',
              objectFit: 'cover' as const,
              opacity: activeImg === i ? 1 : 0,
              transition: 'opacity 500ms ease',
            }}
          />
        ))}
        <div style={{
          position: 'absolute' as const,
          bottom: '16px',
          left: '50%',
          transform: 'translateX(-50%)',
          display: 'flex',
          gap: '8px',
        }}>
          {images.map((_, i) => (
            <button
              key={i}
              onClick={(e) => { e.stopPropagation(); setActiveImg(i); }}
              style={{
                width: '8px',
                height: '8px',
                borderRadius: '50%',
                border: 'none',
                backgroundColor: activeImg === i ? '#ffffff' : 'rgba(255,255,255,0.5)',
                cursor: 'pointer',
                transition: 'all 200ms ease',
              }}
            />
          ))}
        </div>
      </div>
      <div style={{ padding: '20px' }}>
        <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>
          Photo Gallery
        </h3>
        <p style={{ fontSize: '14px', color: '#6b7280', marginBottom: '12px' }}>
          Browse through our collection of stunning images
        </p>
        <div style={{ fontSize: '13px', color: theme.primary || '#3b82f6', fontWeight: '600' }}>
          {activeImg + 1} / {images.length}
        </div>
      </div>
    </div>
  );
};
