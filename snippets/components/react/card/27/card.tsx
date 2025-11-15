// Variant 27: Timeline card with date marker
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  const events = [{ time: '10:00 AM', title: 'Team Meeting', desc: 'Weekly sync-up' }, { time: '2:30 PM', title: 'Project Review', desc: 'Q4 deliverables' }, { time: '4:00 PM', title: 'Client Call', desc: 'Feature discussion' }];
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateX(0)' : 'translateX(-20px)', transition: 'all 350ms ease', padding: '28px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '340px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '24px' }}>Today's Schedule</h3>
      <div style={{ position: 'relative' as const }}>
        <div style={{ position: 'absolute' as const, left: '31px', top: '8px', bottom: '8px', width: '2px', backgroundColor: '#e5e7eb' }} />
        {events.map((event, i) => (
          <div key={i} style={{ position: 'relative' as const, display: 'flex', gap: '16px', marginBottom: i === events.length - 1 ? 0 : '24px' }}>
            <div style={{ flex: '0 0 60px', fontSize: '12px', color: '#9ca3af', fontWeight: '600' }}>{event.time}</div>
            <div style={{ width: '16px', height: '16px', borderRadius: '50%', border: '3px solid #ffffff', backgroundColor: theme.primary || '#3b82f6', boxShadow: '0 0 0 2px #e5e7eb', flexShrink: 0, marginTop: '2px' }} />
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: '15px', fontWeight: '600', color: theme.text || '#111827', marginBottom: '4px' }}>{event.title}</div>
              <div style={{ fontSize: '13px', color: '#6b7280' }}>{event.desc}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
