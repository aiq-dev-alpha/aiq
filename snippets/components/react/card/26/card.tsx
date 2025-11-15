// Variant 26: Metric card with trend indicator
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', padding: '28px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.1)' : '0 4px 12px rgba(0,0,0,0.05)', cursor: 'pointer', width: '260px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '20px' }}>
        <div style={{ fontSize: '14px', color: '#6b7280', textTransform: 'uppercase' as const, letterSpacing: '1px' }}>Sales</div>
        <div style={{ padding: '4px 10px', backgroundColor: '#10b98110', borderRadius: '6px', fontSize: '13px', fontWeight: '600', color: '#10b981' }}>↑ 23.5%</div>
      </div>
      <div style={{ fontSize: '42px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>$12,345</div>
      <div style={{ fontSize: '13px', color: '#9ca3af' }}>vs last month: $10,012</div>
      <div style={{ marginTop: '20px', height: '60px', display: 'flex', alignItems: 'flex-end', gap: '4px' }}>
        {[45, 52, 48, 63, 55, 71, 68, 75, 82].map((h, i) => (
          <div key={i} style={{ flex: 1, height: `${h}%`, backgroundColor: i === 8 ? (theme.primary || '#3b82f6') : '#e5e7eb', borderRadius: '2px', transition: 'all 300ms ease' }} />
        ))}
      </div>
    </div>
  );
};
