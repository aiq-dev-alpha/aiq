// Variant 19: Weather card with icon and temp
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [temp, setTemp] = useState(72);

  useEffect(() => {
    setIsVisible(true);
    const interval = setInterval(() => {
      setTemp(prev => prev + (Math.random() > 0.5 ? 1 : -1));
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  const hourly = [
    { time: '12 PM', temp: 72, icon: '☀️' },
    { time: '3 PM', temp: 75, icon: '🌤️' },
    { time: '6 PM', temp: 68, icon: '🌥️' },
    { time: '9 PM', temp: 62, icon: '🌙' },
  ];

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        borderRadius: '20px',
        padding: '32px',
        boxShadow: isHovered ? '0 20px 40px rgba(102,126,234,0.4)' : '0 10px 25px rgba(102,126,234,0.3)',
        cursor: 'pointer',
        width: '340px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ marginBottom: '24px' }}>
        <div style={{ fontSize: '16px', color: 'rgba(255,255,255,0.9)', marginBottom: '8px' }}>San Francisco, CA</div>
        <div style={{ fontSize: '14px', color: 'rgba(255,255,255,0.7)' }}>Monday, Nov 15</div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '32px' }}>
        <div>
          <div style={{ fontSize: '72px', fontWeight: 'bold', color: '#ffffff', lineHeight: '1', marginBottom: '8px', transition: 'all 500ms ease' }}>
            {temp}°
          </div>
          <div style={{ fontSize: '18px', color: 'rgba(255,255,255,0.9)' }}>Partly Cloudy</div>
        </div>
        <div style={{ fontSize: '80px', filter: 'drop-shadow(0 4px 8px rgba(0,0,0,0.2))' }}>
          ⛅
        </div>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '12px', paddingTop: '20px', borderTop: '1px solid rgba(255,255,255,0.2)' }}>
        {hourly.map((item, i) => (
          <div key={i} style={{ textAlign: 'center' as const }}>
            <div style={{ fontSize: '12px', color: 'rgba(255,255,255,0.7)', marginBottom: '8px' }}>{item.time}</div>
            <div style={{ fontSize: '28px', marginBottom: '4px' }}>{item.icon}</div>
            <div style={{ fontSize: '14px', fontWeight: '600', color: '#ffffff' }}>{item.temp}°</div>
          </div>
        ))}
      </div>
      <div style={{ marginTop: '20px', display: 'flex', gap: '16px', fontSize: '13px', color: 'rgba(255,255,255,0.8)' }}>
        <span>💧 65%</span>
        <span>💨 12 mph</span>
        <span>👁️ 10 mi</span>
      </div>
    </div>
  );
};
