// Variant 31: Team member card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? (isHovered ? 'translateY(-8px)' : 'translateY(0)') : 'translateY(20px)', transition: 'all 300ms ease', padding: '28px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)', cursor: 'pointer', width: '280px', textAlign: 'center' as const }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80" alt="Team member" style={{ width: '96px', height: '96px', borderRadius: '50%', objectFit: 'cover' as const, marginBottom: '16px', border: `4px solid ${theme.primary || '#3b82f6'}20` }} />
      <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>Emma Wilson</h3>
      <div style={{ fontSize: '14px', color: theme.primary || '#3b82f6', marginBottom: '12px', fontWeight: '500' }}>Lead Developer</div>
      <p style={{ fontSize: '13px', color: '#6b7280', lineHeight: '1.6', marginBottom: '20px' }}>Full-stack developer with 8 years of experience in React and Node.js</p>
      <div style={{ display: 'flex', gap: '8px', justifyContent: 'center' }}>
        {['🐙', '💼', '🐦'].map((icon, i) => (
          <div key={i} style={{ width: '36px', height: '36px', borderRadius: '8px', backgroundColor: '#f3f4f6', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '18px', cursor: 'pointer' }}>{icon}</div>
        ))}
      </div>
    </div>
  );
};
