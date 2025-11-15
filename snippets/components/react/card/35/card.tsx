// Variant 35: Dashboard widget card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  const data = [65, 59, 80, 81, 56, 72, 69];
  const max = Math.max(...data);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', padding: '24px', background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`, borderRadius: '16px', boxShadow: isHovered ? '0 16px 32px rgba(59,130,246,0.3)' : '0 8px 20px rgba(59,130,246,0.2)', cursor: 'pointer', width: '320px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '20px' }}>
        <div>
          <div style={{ fontSize: '14px', color: 'rgba(255,255,255,0.8)', marginBottom: '8px', textTransform: 'uppercase' as const, letterSpacing: '1px' }}>Active Users</div>
          <div style={{ fontSize: '36px', fontWeight: 'bold', color: '#ffffff', lineHeight: '1' }}>8,549</div>
        </div>
        <div style={{ padding: '8px 14px', backgroundColor: 'rgba(16,185,129,0.2)', backdropFilter: 'blur(10px)', borderRadius: '8px', fontSize: '14px', fontWeight: '600', color: '#10b981' }}>+12.3%</div>
      </div>
      <div style={{ display: 'flex', alignItems: 'flex-end', gap: '3px', height: '80px', marginBottom: '16px' }}>
        {data.map((val, i) => (
          <div key={i} style={{ flex: 1, height: `${(val / max) * 100}%`, backgroundColor: 'rgba(255,255,255,0.3)', borderRadius: '3px 3px 0 0', transition: 'all 300ms ease', transform: isHovered ? 'scaleY(1.05)' : 'scaleY(1)' }} />
        ))}
      </div>
      <div style={{ display: 'flex', gap: '24px', fontSize: '13px', color: 'rgba(255,255,255,0.9)' }}>
        <div><span style={{ color: 'rgba(255,255,255,0.7)' }}>Peak:</span> 11:00 AM</div>
        <div><span style={{ color: 'rgba(255,255,255,0.7)' }}>Avg:</span> 6,234</div>
      </div>
    </div>
  );
};
