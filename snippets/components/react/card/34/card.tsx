// Variant 34: Review card with star rating
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [rating, setRating] = useState(5);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'translateY(0)' : 'translateY(20px)', transition: 'all 300ms ease', padding: '28px', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '340px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px', marginBottom: '16px' }}>
        <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb" alt="Reviewer" style={{ width: '56px', height: '56px', borderRadius: '50%', objectFit: 'cover' as const }} />
        <div>
          <div style={{ fontSize: '16px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '4px' }}>Rachel Green</div>
          <div style={{ display: 'flex', gap: '4px' }}>
            {[1, 2, 3, 4, 5].map((star) => (
              <span key={star} style={{ color: star <= rating ? '#fbbf24' : '#e5e7eb', fontSize: '18px', cursor: 'pointer' }} onClick={(e) => { e.stopPropagation(); setRating(star); }}>★</span>
            ))}
          </div>
        </div>
      </div>
      <p style={{ fontSize: '15px', color: theme.text || '#111827', lineHeight: '1.7', marginBottom: '16px', fontStyle: 'italic' }}>
        "Absolutely love this product! It exceeded my expectations in every way. The quality is outstanding and customer service was fantastic."
      </p>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', paddingTop: '16px', borderTop: '1px solid #e5e7eb' }}>
        <div style={{ fontSize: '13px', color: '#9ca3af' }}>Verified Purchase  •  Nov 10, 2024</div>
        <div style={{ display: 'flex', gap: '12px', fontSize: '13px', color: '#6b7280' }}>
          <span style={{ cursor: 'pointer' }}>👍 24</span>
          <span style={{ cursor: 'pointer' }}>💬 Reply</span>
        </div>
      </div>
    </div>
  );
};
