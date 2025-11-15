// Variant 11: Stats card with large numbers
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [count, setCount] = useState(0);

  useEffect(() => {
    setIsVisible(true);
    const timer = setTimeout(() => {
      let current = 0;
      const target = 24567;
      const increment = target / 50;
      const interval = setInterval(() => {
        current += increment;
        if (current >= target) {
          setCount(target);
          clearInterval(interval);
        } else {
          setCount(Math.floor(current));
        }
      }, 20);
      return () => clearInterval(interval);
    }, 100);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.9)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '40px',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
        borderRadius: '20px',
        boxShadow: isHovered ? '0 20px 40px rgba(59,130,246,0.4)' : '0 10px 25px rgba(59,130,246,0.2)',
        cursor: 'pointer',
        width: '320px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ fontSize: '14px', color: 'rgba(255,255,255,0.8)', textTransform: 'uppercase' as const, letterSpacing: '2px', marginBottom: '12px' }}>
        Total Revenue
      </div>
      <div style={{ fontSize: '56px', fontWeight: 'bold', color: '#ffffff', marginBottom: '8px', transition: 'transform 300ms ease', transform: isHovered ? 'scale(1.05)' : 'scale(1)' }}>
        ${count.toLocaleString()}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '16px', color: 'rgba(255,255,255,0.9)', marginBottom: '24px' }}>
        <span style={{ color: '#10b981', fontSize: '20px' }}>↑</span>
        <span>+12.5% from last month</span>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px' }}>
        {[
          { label: 'Orders', value: '1,234' },
          { label: 'Customers', value: '892' },
        ].map((stat, i) => (
          <div key={i} style={{ padding: '16px', backgroundColor: 'rgba(255,255,255,0.1)', borderRadius: '12px', backdropFilter: 'blur(10px)' }}>
            <div style={{ fontSize: '24px', fontWeight: 'bold', color: '#ffffff', marginBottom: '4px' }}>{stat.value}</div>
            <div style={{ fontSize: '12px', color: 'rgba(255,255,255,0.7)' }}>{stat.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
};
