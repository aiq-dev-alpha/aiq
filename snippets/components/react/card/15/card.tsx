// Variant 15: Video card with play button overlay
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
        backgroundColor: theme.background || '#000000',
        borderRadius: '16px',
        overflow: 'hidden',
        boxShadow: isHovered ? '0 20px 40px rgba(0,0,0,0.3)' : '0 8px 20px rgba(0,0,0,0.2)',
        cursor: 'pointer',
        width: '400px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ position: 'relative' as const, paddingTop: '56.25%', backgroundColor: '#1a1a1a' }}>
        <img
          src="https://images.unsplash.com/photo-1536240478700-b869070f9279"
          alt="Video thumbnail"
          style={{
            position: 'absolute' as const,
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            objectFit: 'cover' as const,
            filter: isPlaying ? 'brightness(0.4)' : 'brightness(0.8)',
            transition: 'all 300ms ease',
          }}
        />
        <div
          onClick={(e) => { e.stopPropagation(); setIsPlaying(!isPlaying); }}
          style={{
            position: 'absolute' as const,
            top: '50%',
            left: '50%',
            transform: `translate(-50%, -50%) scale(${isHovered ? 1.1 : 1})`,
            width: '80px',
            height: '80px',
            borderRadius: '50%',
            backgroundColor: isPlaying ? 'rgba(239,68,68,0.9)' : `rgba(${theme.primary ? '59,130,246' : '59,130,246'},0.9)`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            cursor: 'pointer',
            transition: 'all 300ms ease',
            boxShadow: '0 8px 24px rgba(0,0,0,0.4)',
          }}
        >
          <div style={{ color: '#ffffff', fontSize: '32px', marginLeft: isPlaying ? '0' : '4px' }}>
            {isPlaying ? '⏸' : '▶'}
          </div>
        </div>
        <div style={{
          position: 'absolute' as const,
          bottom: '12px',
          right: '12px',
          padding: '4px 8px',
          backgroundColor: 'rgba(0,0,0,0.8)',
          borderRadius: '4px',
          fontSize: '12px',
          color: '#ffffff',
          fontWeight: '600',
        }}>
          12:45
        </div>
      </div>
      <div style={{ padding: '20px' }}>
        <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: '#ffffff', marginBottom: '8px', lineHeight: '1.4' }}>
          Building Modern Web Applications
        </h3>
        <p style={{ fontSize: '13px', color: '#9ca3af', lineHeight: '1.5', marginBottom: '16px' }}>
          Learn the fundamentals of modern web development with React and TypeScript.
        </p>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <img
              src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde"
              alt="Creator"
              style={{ width: '32px', height: '32px', borderRadius: '50%', objectFit: 'cover' as const }}
            />
            <div>
              <div style={{ fontSize: '13px', fontWeight: '600', color: '#ffffff' }}>Code Academy</div>
              <div style={{ fontSize: '12px', color: '#6b7280' }}>24K subscribers</div>
            </div>
          </div>
          <div style={{ fontSize: '13px', color: '#9ca3af' }}>•  2.4K views</div>
        </div>
      </div>
    </div>
  );
};
