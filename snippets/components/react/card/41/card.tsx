// Variant 41: Map location card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', overflow: 'hidden', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)', cursor: 'pointer', width: '360px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ position: 'relative' as const, height: '200px', backgroundColor: '#f3f4f6', backgroundImage: 'radial-gradient(circle at 30% 50%, #e5e7eb 0%, #f3f4f6 50%)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ fontSize: '64px' }}>🗺️</div>
        <div style={{ position: 'absolute' as const, top: '50%', left: '50%', width: '40px', height: '40px', transform: 'translate(-50%, -100%)', fontSize: '40px', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.2))' }}>📍</div>
      </div>
      <div style={{ padding: '20px' }}>
        <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>Coffee House Downtown</h3>
        <div style={{ fontSize: '14px', color: '#6b7280', marginBottom: '16px' }}>123 Main Street, San Francisco, CA 94102</div>
        <div style={{ display: 'flex', flexDirection: 'column' as const, gap: '8px', marginBottom: '16px', fontSize: '13px', color: '#6b7280' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>⭐</span><span>4.8 (234 reviews)</span></div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>🕐</span><span>Open until 9:00 PM</span></div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}><span>📞</span><span>(415) 555-1234</span></div>
        </div>
        <div style={{ display: 'flex', gap: '12px' }}>
          <button style={{ flex: 1, padding: '10px', borderRadius: '8px', border: 'none', backgroundColor: theme.primary || '#3b82f6', color: '#ffffff', fontSize: '14px', fontWeight: '600', cursor: 'pointer' }}>
            Directions
          </button>
          <button style={{ flex: 1, padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb', backgroundColor: 'transparent', color: theme.text || '#111827', fontSize: '14px', fontWeight: '600', cursor: 'pointer' }}>
            Call
          </button>
        </div>
      </div>
    </div>
  );
};
