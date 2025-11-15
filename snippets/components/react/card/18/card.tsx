// Variant 18: Contact card (business card style)
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
        transform: isVisible ? (isHovered ? 'rotateY(5deg) rotateX(-2deg)' : 'rotateY(0deg) rotateX(0deg)') : 'scale(0.95)',
        transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
        borderRadius: '16px',
        padding: '32px',
        boxShadow: isHovered ? '0 20px 40px rgba(59,130,246,0.3)' : '0 10px 25px rgba(59,130,246,0.2)',
        cursor: 'pointer',
        width: '360px',
        transformStyle: 'preserve-3d' as const,
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '24px' }}>
        <div>
          <h3 style={{ fontSize: '28px', fontWeight: 'bold', color: '#ffffff', marginBottom: '4px' }}>Jessica Chen</h3>
          <div style={{ fontSize: '16px', color: 'rgba(255,255,255,0.9)', marginBottom: '16px' }}>Senior UX Designer</div>
        </div>
        <div style={{ width: '60px', height: '60px', borderRadius: '12px', backgroundColor: 'rgba(255,255,255,0.2)', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '32px', backdropFilter: 'blur(10px)' }}>
          👩‍💼
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column' as const, gap: '12px', marginBottom: '24px' }}>
        {[
          { icon: '📧', text: 'jessica.chen@company.com' },
          { icon: '📱', text: '+1 (555) 123-4567' },
          { icon: '🌐', text: 'www.jessicachen.design' },
          { icon: '📍', text: 'San Francisco, CA' },
        ].map((item, i) => (
          <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '12px', color: '#ffffff', fontSize: '14px' }}>
            <span style={{ fontSize: '18px' }}>{item.icon}</span>
            <span>{item.text}</span>
          </div>
        ))}
      </div>
      <div style={{ display: 'flex', gap: '12px', paddingTop: '20px', borderTop: '1px solid rgba(255,255,255,0.2)' }}>
        {['LinkedIn', 'Twitter', 'GitHub'].map((platform, i) => (
          <div key={i} style={{
            flex: 1,
            padding: '10px',
            backgroundColor: 'rgba(255,255,255,0.15)',
            borderRadius: '8px',
            textAlign: 'center' as const,
            color: '#ffffff',
            fontSize: '12px',
            fontWeight: '600',
            backdropFilter: 'blur(10px)',
          }}>
            {platform}
          </div>
        ))}
      </div>
    </div>
  );
};
