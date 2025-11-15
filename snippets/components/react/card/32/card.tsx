// Variant 32: Service card with pricing
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', padding: '32px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', border: `2px solid ${isHovered ? (theme.primary || '#3b82f6') : '#f3f4f6'}`, boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '300px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ width: '56px', height: '56px', borderRadius: '14px', background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '28px', marginBottom: '20px' }}>💻</div>
      <h3 style={{ fontSize: '22px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '12px' }}>Web Development</h3>
      <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.6', marginBottom: '24px' }}>Custom websites and web applications built with modern technologies</p>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px', marginBottom: '20px' }}>
        <span style={{ fontSize: '36px', fontWeight: 'bold', color: theme.primary || '#3b82f6' }}>$2,500</span>
        <span style={{ fontSize: '14px', color: '#9ca3af' }}>starting from</span>
      </div>
      <ul style={{ listStyle: 'none', padding: 0, margin: '0 0 24px 0', fontSize: '13px', color: '#6b7280' }}>
        {['Responsive design', 'SEO optimized', 'Fast performance', '30-day support'].map((f, i) => (
          <li key={i} style={{ padding: '8px 0', display: 'flex', gap: '10px' }}><span style={{ color: theme.primary || '#3b82f6' }}>✓</span><span>{f}</span></li>
        ))}
      </ul>
      <button style={{ width: '100%', padding: '12px', borderRadius: '10px', border: 'none', backgroundColor: theme.primary || '#3b82f6', color: '#ffffff', fontSize: '15px', fontWeight: '600', cursor: 'pointer' }}>Get Started</button>
    </div>
  );
};
