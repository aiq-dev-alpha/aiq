// Variant 30: News card with source logo
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '12px', overflow: 'hidden', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '360px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', gap: '16px', padding: '20px' }}>
        <img src="https://images.unsplash.com/photo-1504711434969-e33886168f5c" alt="News" style={{ width: '120px', height: '120px', objectFit: 'cover' as const, borderRadius: '8px', flexShrink: 0 }} />
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '8px' }}>
            <div style={{ width: '24px', height: '24px', borderRadius: '4px', backgroundColor: theme.primary || '#3b82f6', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#ffffff', fontSize: '12px', fontWeight: 'bold' }}>TN</div>
            <span style={{ fontSize: '12px', fontWeight: '600', color: theme.text || '#111827' }}>Tech News</span>
            <span style={{ fontSize: '12px', color: '#9ca3af' }}>• 2h ago</span>
          </div>
          <h3 style={{ fontSize: '16px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '8px', lineHeight: '1.4' }}>
            AI Breakthrough: New Model Achieves Human-Level Performance
          </h3>
          <p style={{ fontSize: '13px', color: '#6b7280', lineHeight: '1.5' }}>
            Researchers announce major advancement in artificial intelligence...
          </p>
        </div>
      </div>
      <div style={{ padding: '12px 20px', backgroundColor: '#f9fafb', display: 'flex', gap: '16px', fontSize: '13px', color: '#6b7280' }}>
        <span>👁️ 12.4K views</span>
        <span>💬 234 comments</span>
        <span>📤 Share</span>
      </div>
    </div>
  );
};
