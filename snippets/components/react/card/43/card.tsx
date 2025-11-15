// Variant 43: Grid card layout
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  const items = [
    { icon: '📊', label: 'Analytics', count: '1,234' },
    { icon: '👥', label: 'Users', count: '892' },
    { icon: '💰', label: 'Revenue', count: '$45K' },
    { icon: '📈', label: 'Growth', count: '+23%' }
  ];
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', padding: '24px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '320px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '20px' }}>Dashboard Overview</h3>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
        {items.map((item, i) => (
          <div key={i} style={{ padding: '20px', backgroundColor: '#f9fafb', borderRadius: '12px', textAlign: 'center' as const, transition: 'all 200ms ease', transform: isHovered ? 'translateY(-4px)' : 'translateY(0)' }}>
            <div style={{ fontSize: '32px', marginBottom: '8px' }}>{item.icon}</div>
            <div style={{ fontSize: '24px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>{item.count}</div>
            <div style={{ fontSize: '13px', color: '#6b7280', fontWeight: '500' }}>{item.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
};
