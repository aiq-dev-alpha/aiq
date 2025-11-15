// Variant 40: Chart/graph card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  const data = [
    { label: 'Mon', value: 45 },
    { label: 'Tue', value: 52 },
    { label: 'Wed', value: 38 },
    { label: 'Thu', value: 68 },
    { label: 'Fri', value: 75 },
    { label: 'Sat', value: 62 },
    { label: 'Sun', value: 51 }
  ];
  const maxValue = Math.max(...data.map(d => d.value));
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', padding: '28px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '380px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '24px' }}>
        <div>
          <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>Weekly Activity</h3>
          <div style={{ fontSize: '13px', color: '#9ca3af' }}>Total: 391 activities</div>
        </div>
        <select style={{ padding: '6px 10px', borderRadius: '6px', border: '1px solid #e5e7eb', fontSize: '13px', color: theme.text || '#111827', backgroundColor: 'transparent', cursor: 'pointer' }}>
          <option>This Week</option>
          <option>Last Week</option>
          <option>This Month</option>
        </select>
      </div>
      <div style={{ display: 'flex', alignItems: 'flex-end', gap: '8px', height: '150px', marginBottom: '12px' }}>
        {data.map((item, i) => (
          <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column' as const, alignItems: 'center', gap: '8px' }}>
            <div style={{ flex: 1, width: '100%', display: 'flex', alignItems: 'flex-end' }}>
              <div style={{ width: '100%', height: `${(item.value / maxValue) * 100}%`, background: `linear-gradient(to top, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`, borderRadius: '6px 6px 0 0', transition: 'all 300ms ease', transform: isHovered ? 'scaleY(1.05)' : 'scaleY(1)' }} />
            </div>
            <div style={{ fontSize: '11px', color: '#9ca3af', fontWeight: '500' }}>{item.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
};
