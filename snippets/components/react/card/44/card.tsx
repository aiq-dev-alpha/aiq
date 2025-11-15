// Variant 44: List card with items
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  const items = [
    { name: 'Design System Update', time: '2 hours ago', status: 'Completed' },
    { name: 'API Integration', time: 'In Progress', status: 'Active' },
    { name: 'User Testing', time: 'Tomorrow', status: 'Pending' }
  ];
  const getStatusColor = (status: string) => {
    if (status === 'Completed') return '#10b981';
    if (status === 'Active') return '#3b82f6';
    return '#9ca3af';
  };
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateY(0)' : 'translateY(20px)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '360px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ padding: '20px 24px', borderBottom: '1px solid #e5e7eb' }}>
        <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: theme.text || '#111827' }}>Recent Activities</h3>
      </div>
      <div>
        {items.map((item, i) => (
          <div key={i} style={{ padding: '16px 24px', borderBottom: i === items.length - 1 ? 'none' : '1px solid #e5e7eb', display: 'flex', alignItems: 'center', justifyContent: 'space-between', transition: 'background-color 200ms ease', backgroundColor: 'transparent' }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: '15px', fontWeight: '600', color: theme.text || '#111827', marginBottom: '4px' }}>{item.name}</div>
              <div style={{ fontSize: '13px', color: '#9ca3af' }}>{item.time}</div>
            </div>
            <div style={{ padding: '6px 12px', borderRadius: '6px', backgroundColor: `${getStatusColor(item.status)}15`, color: getStatusColor(item.status), fontSize: '12px', fontWeight: '600' }}>
              {item.status}
            </div>
          </div>
        ))}
      </div>
      <div style={{ padding: '16px 24px' }}>
        <button style={{ width: '100%', padding: '10px', borderRadius: '8px', border: '1px solid #e5e7eb', backgroundColor: 'transparent', color: theme.text || '#111827', fontSize: '14px', fontWeight: '600', cursor: 'pointer' }}>
          View All
        </button>
      </div>
    </div>
  );
};
