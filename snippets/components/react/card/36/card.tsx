// Variant 36: Calendar event card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateX(0)' : 'translateX(-30px)', transition: 'all 350ms ease', display: 'flex', gap: '16px', padding: '20px', backgroundColor: theme.background || '#ffffff', borderRadius: '12px', borderLeft: `4px solid ${theme.primary || '#3b82f6'}`, boxShadow: isHovered ? '0 8px 20px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '380px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ textAlign: 'center' as const, minWidth: '60px' }}>
        <div style={{ fontSize: '12px', color: '#9ca3af', textTransform: 'uppercase' as const, letterSpacing: '1px', marginBottom: '4px' }}>DEC</div>
        <div style={{ fontSize: '32px', fontWeight: 'bold', color: theme.primary || '#3b82f6', lineHeight: '1' }}>15</div>
        <div style={{ fontSize: '12px', color: '#6b7280', marginTop: '4px' }}>Monday</div>
      </div>
      <div style={{ flex: 1 }}>
        <h4 style={{ fontSize: '17px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>Product Launch Meeting</h4>
        <div style={{ display: 'flex', flexDirection: 'column' as const, gap: '6px', fontSize: '13px', color: '#6b7280' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>🕐</span><span>2:00 PM - 3:30 PM</span></div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>📍</span><span>Conference Room A</span></div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>👥</span><span>8 attendees</span></div>
        </div>
      </div>
      <button style={{ alignSelf: 'flex-start', padding: '8px 16px', borderRadius: '8px', border: 'none', backgroundColor: `${theme.primary || '#3b82f6'}15`, color: theme.primary || '#3b82f6', fontSize: '13px', fontWeight: '600', cursor: 'pointer' }}>Join</button>
    </div>
  );
};
