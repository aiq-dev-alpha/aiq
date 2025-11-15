// Variant 8: Neumorphism card with soft shadows
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isPressed, setIsPressed] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  const bgColor = theme.background || '#e0e5ec';

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '36px',
        backgroundColor: bgColor,
        borderRadius: '24px',
        boxShadow: isPressed
          ? 'inset 6px 6px 12px rgba(163, 177, 198, 0.6), inset -6px -6px 12px rgba(255, 255, 255, 0.5)'
          : isHovered
            ? '10px 10px 20px rgba(163, 177, 198, 0.5), -10px -10px 20px rgba(255, 255, 255, 0.8)'
            : '8px 8px 16px rgba(163, 177, 198, 0.4), -8px -8px 16px rgba(255, 255, 255, 0.7)',
        cursor: 'pointer',
        width: '300px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); setIsPressed(false); onHover?.(false); }}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
    >
      <div style={{
        width: '80px',
        height: '80px',
        borderRadius: '20px',
        backgroundColor: bgColor,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: '24px',
        fontSize: '36px',
        boxShadow: isPressed
          ? 'inset 4px 4px 8px rgba(163, 177, 198, 0.4), inset -4px -4px 8px rgba(255, 255, 255, 0.4)'
          : '6px 6px 12px rgba(163, 177, 198, 0.4), -6px -6px 12px rgba(255, 255, 255, 0.7)',
        transition: 'all 200ms ease',
      }}>
        🎯
      </div>
      <h3 style={{ fontSize: '24px', fontWeight: 'bold', color: '#4a5568', marginBottom: '12px', textShadow: '1px 1px 2px rgba(255, 255, 255, 0.8)' }}>
        Neumorphism Card
      </h3>
      <p style={{ fontSize: '14px', color: '#718096', lineHeight: '1.6', marginBottom: '24px' }}>
        Soft UI design with embossed and debossed elements creating a tactile, physical appearance.
      </p>
      <div style={{ marginBottom: '24px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', color: '#718096', marginBottom: '8px' }}>
          <span>Progress</span>
          <span>75%</span>
        </div>
        <div style={{
          width: '100%',
          height: '12px',
          borderRadius: '10px',
          backgroundColor: bgColor,
          boxShadow: 'inset 3px 3px 6px rgba(163, 177, 198, 0.4), inset -3px -3px 6px rgba(255, 255, 255, 0.5)',
          overflow: 'hidden',
        }}>
          <div style={{
            height: '100%',
            width: '75%',
            background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
            borderRadius: '10px',
            transition: 'width 400ms ease',
          }} />
        </div>
      </div>
      <button style={{
        width: '100%',
        padding: '14px',
        borderRadius: '12px',
        border: 'none',
        backgroundColor: bgColor,
        color: '#4a5568',
        fontSize: '15px',
        fontWeight: '600',
        cursor: 'pointer',
        boxShadow: isPressed
          ? 'inset 4px 4px 8px rgba(163, 177, 198, 0.4), inset -4px -4px 8px rgba(255, 255, 255, 0.4)'
          : '5px 5px 10px rgba(163, 177, 198, 0.4), -5px -5px 10px rgba(255, 255, 255, 0.7)',
        transition: 'all 200ms ease',
        textShadow: '1px 1px 2px rgba(255, 255, 255, 0.5)',
      }}>
        View Details
      </button>
    </div>
  );
};
