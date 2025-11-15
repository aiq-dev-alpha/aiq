// Variant 14: Event card with date badge
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isRegistered, setIsRegistered] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        display: 'flex',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        overflow: 'hidden',
        boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)',
        cursor: 'pointer',
        width: '420px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{
        flex: '0 0 120px',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
        display: 'flex',
        flexDirection: 'column' as const,
        alignItems: 'center',
        justifyContent: 'center',
        color: '#ffffff',
      }}>
        <div style={{ fontSize: '36px', fontWeight: 'bold', lineHeight: '1' }}>15</div>
        <div style={{ fontSize: '18px', textTransform: 'uppercase' as const, letterSpacing: '1px' }}>DEC</div>
        <div style={{ fontSize: '14px', opacity: 0.9 }}>2024</div>
      </div>
      <div style={{ flex: 1, padding: '24px' }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', marginBottom: '12px' }}>
          <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', lineHeight: '1.3' }}>
            Web Development Conference 2024
          </h3>
        </div>
        <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.6', marginBottom: '16px' }}>
          Join industry leaders for a day of workshops, networking, and innovation.
        </p>
        <div style={{ display: 'flex', flexDirection: 'column' as const, gap: '8px', marginBottom: '16px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '13px', color: '#6b7280' }}>
            <span>🕒</span>
            <span>9:00 AM - 5:00 PM PST</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '13px', color: '#6b7280' }}>
            <span>📍</span>
            <span>San Francisco Convention Center</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '13px', color: '#6b7280' }}>
            <span>👥</span>
            <span>234 attendees registered</span>
          </div>
        </div>
        <button
          onClick={(e) => { e.stopPropagation(); setIsRegistered(!isRegistered); }}
          style={{
            padding: '10px 24px',
            borderRadius: '8px',
            border: 'none',
            backgroundColor: isRegistered ? '#10b981' : (theme.primary || '#3b82f6'),
            color: '#ffffff',
            fontSize: '14px',
            fontWeight: '600',
            cursor: 'pointer',
            transition: 'all 200ms ease',
          }}
        >
          {isRegistered ? '✓ Registered' : 'Register Now'}
        </button>
      </div>
    </div>
  );
};
