// Variant 33: Portfolio card with project details
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', overflow: 'hidden', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)', cursor: 'pointer', width: '360px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ position: 'relative' as const, height: '200px', overflow: 'hidden' }}>
        <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f" alt="Project" style={{ width: '100%', height: '100%', objectFit: 'cover' as const, transition: 'transform 400ms ease', transform: isHovered ? 'scale(1.1)' : 'scale(1)' }} />
        <div style={{ position: 'absolute' as const, top: '16px', right: '16px', padding: '6px 12px', backgroundColor: 'rgba(0,0,0,0.7)', backdropFilter: 'blur(10px)', borderRadius: '8px', color: '#ffffff', fontSize: '12px', fontWeight: '600' }}>Featured</div>
      </div>
      <div style={{ padding: '24px' }}>
        <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px' }}>E-Commerce Platform</h3>
        <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.6', marginBottom: '16px' }}>A modern e-commerce solution with real-time inventory management and payment processing</p>
        <div style={{ display: 'flex', flexWrap: 'wrap' as const, gap: '8px', marginBottom: '16px' }}>
          {['React', 'Node.js', 'MongoDB'].map((tech, i) => (
            <span key={i} style={{ padding: '4px 10px', backgroundColor: '#f3f4f6', borderRadius: '6px', fontSize: '12px', color: '#6b7280', fontWeight: '500' }}>{tech}</span>
          ))}
        </div>
        <div style={{ display: 'flex', gap: '12px', fontSize: '13px', color: '#9ca3af' }}>
          <span>⭐ 45</span>
          <span>🍴 12 forks</span>
          <span>👁️ 234 views</span>
        </div>
      </div>
    </div>
  );
};
