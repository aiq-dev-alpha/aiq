// Variant 45: Collapsible card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateY(0)' : 'translateY(20px)', transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '360px', overflow: 'hidden' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div onClick={(e) => { e.stopPropagation(); setIsExpanded(!isExpanded); }} style={{ padding: '24px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <div style={{ width: '48px', height: '48px', borderRadius: '12px', background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '24px' }}>📦</div>
          <div>
            <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>Project Details</h3>
            <div style={{ fontSize: '13px', color: '#9ca3af' }}>Click to {isExpanded ? 'collapse' : 'expand'}</div>
          </div>
        </div>
        <div style={{ fontSize: '20px', color: '#6b7280', transition: 'transform 300ms ease', transform: isExpanded ? 'rotate(180deg)' : 'rotate(0deg)' }}>
          ▼
        </div>
      </div>
      <div style={{ maxHeight: isExpanded ? '400px' : '0', overflow: 'hidden', transition: 'max-height 400ms cubic-bezier(0.4, 0, 0.2, 1)' }}>
        <div style={{ padding: '0 24px 24px', borderTop: '1px solid #e5e7eb', paddingTop: '20px' }}>
          <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.7', marginBottom: '16px' }}>
            This project includes comprehensive documentation, testing suite, and deployment automation. All components are production-ready and follow industry best practices.
          </p>
          <div style={{ display: 'flex', flexDirection: 'column' as const, gap: '12px' }}>
            {['Component Library', 'Testing Framework', 'CI/CD Pipeline', 'Documentation'].map((item, i) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '10px', fontSize: '14px', color: theme.text || '#111827' }}>
                <span style={{ color: theme.primary || '#3b82f6' }}>✓</span>
                <span>{item}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
