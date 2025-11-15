// Variant 39: File preview card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateY(0)' : 'translateY(20px)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '12px', border: `1px solid ${isHovered ? (theme.primary || '#3b82f6') : '#e5e7eb'}`, boxShadow: isHovered ? `0 8px 16px ${theme.primary || '#3b82f6'}20` : '0 2px 8px rgba(0,0,0,0.04)', cursor: 'pointer', width: '320px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ padding: '20px', display: 'flex', gap: '16px' }}>
        <div style={{ width: '56px', height: '56px', borderRadius: '10px', background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#ffffff', fontSize: '24px', fontWeight: 'bold', flexShrink: 0 }}>
          PDF
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <h4 style={{ fontSize: '15px', fontWeight: '600', color: theme.text || '#111827', marginBottom: '6px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' as const }}>
            Q4_Financial_Report_2024.pdf
          </h4>
          <div style={{ fontSize: '13px', color: '#6b7280', marginBottom: '8px' }}>2.4 MB  •  Modified Nov 10, 2024</div>
          <div style={{ fontSize: '12px', color: '#9ca3af' }}>Shared by John Smith</div>
        </div>
      </div>
      <div style={{ padding: '16px 20px', backgroundColor: '#f9fafb', borderTop: '1px solid #e5e7eb', display: 'flex', gap: '12px', fontSize: '13px' }}>
        <button style={{ flex: 1, padding: '8px', borderRadius: '6px', border: 'none', backgroundColor: theme.primary || '#3b82f6', color: '#ffffff', fontWeight: '600', cursor: 'pointer' }}>
          Open
        </button>
        <button style={{ flex: 1, padding: '8px', borderRadius: '6px', border: '1px solid #e5e7eb', backgroundColor: 'transparent', color: theme.text || '#111827', fontWeight: '600', cursor: 'pointer' }}>
          Download
        </button>
      </div>
    </div>
  );
};
