// Variant 10: Flip card (3D rotation animation)
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isFlipped, setIsFlipped] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  const cardFaceBase: React.CSSProperties = {
    position: 'absolute' as const,
    width: '100%',
    height: '100%',
    backfaceVisibility: 'hidden' as const,
    WebkitBackfaceVisibility: 'hidden' as const,
    borderRadius: '20px',
    boxShadow: '0 8px 24px rgba(0,0,0,0.15)',
    overflow: 'hidden',
  };

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transition: 'opacity 300ms ease',
        perspective: '1000px',
        width: '320px',
        height: '400px',
        cursor: 'pointer',
      }}
      onClick={() => { setIsFlipped(!isFlipped); onHover?.(!isFlipped); }}
    >
      <div style={{
        position: 'relative',
        width: '100%',
        height: '100%',
        transformStyle: 'preserve-3d' as const,
        transition: 'transform 600ms cubic-bezier(0.4, 0, 0.2, 1)',
        transform: isFlipped ? 'rotateY(180deg)' : 'rotateY(0deg)',
      }}>
        <div style={{
          ...cardFaceBase,
          background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
          display: 'flex',
          flexDirection: 'column' as const,
          alignItems: 'center',
          justifyContent: 'center',
          padding: '32px',
        }}>
          <div style={{ fontSize: '80px', marginBottom: '24px' }}>💳</div>
          <h3 style={{ fontSize: '28px', fontWeight: 'bold', color: '#ffffff', marginBottom: '12px', textAlign: 'center' as const }}>
            Premium Card
          </h3>
          <p style={{ fontSize: '16px', color: 'rgba(255, 255, 255, 0.9)', textAlign: 'center' as const, marginBottom: '24px' }}>
            Exclusive Member Benefits
          </p>
          <div style={{ fontSize: '13px', color: 'rgba(255, 255, 255, 0.8)', textAlign: 'center' as const, marginTop: 'auto' }}>
            Click to flip →
          </div>
        </div>
        <div style={{
          ...cardFaceBase,
          backgroundColor: theme.background || '#ffffff',
          transform: 'rotateY(180deg)',
          padding: '32px',
          display: 'flex',
          flexDirection: 'column' as const,
        }}>
          <h3 style={{ fontSize: '24px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '16px' }}>
            Card Details
          </h3>
          <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.7', marginBottom: '24px' }}>
            Enjoy exclusive perks and rewards with your premium membership.
          </p>
          <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 24px 0' }}>
            {[
              { label: 'Card Number', value: '•••• 4567' },
              { label: 'Expires', value: '12/28' },
              { label: 'Rewards Points', value: '12,450' },
            ].map((item, i) => (
              <li key={i} style={{
                padding: '12px 0',
                borderBottom: '1px solid #e5e7eb',
                display: 'flex',
                justifyContent: 'space-between',
                fontSize: '14px',
              }}>
                <span>{item.label}</span>
                <span>{item.value}</span>
              </li>
            ))}
          </ul>
          <button style={{
            marginTop: 'auto',
            padding: '12px',
            borderRadius: '10px',
            border: 'none',
            backgroundColor: theme.primary || '#3b82f6',
            color: '#ffffff',
            fontSize: '15px',
            fontWeight: '600',
            cursor: 'pointer',
          }}>
            Manage Card
          </button>
        </div>
      </div>
    </div>
  );
};
