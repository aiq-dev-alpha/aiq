// Variant 37: Social media post card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [likes, setLikes] = useState(234);
  const [liked, setLiked] = useState(false);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '12px', boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)', cursor: 'pointer', width: '380px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ padding: '16px 20px', display: 'flex', alignItems: 'center', gap: '12px' }}>
        <img src="https://images.unsplash.com/photo-1527980965255-d3b416303d12" alt="User" style={{ width: '48px', height: '48px', borderRadius: '50%', objectFit: 'cover' as const }} />
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: '15px', fontWeight: '600', color: theme.text || '#111827' }}>Design Studio</div>
          <div style={{ fontSize: '12px', color: '#9ca3af' }}>@designstudio  •  3h ago</div>
        </div>
        <button style={{ fontSize: '20px', background: 'none', border: 'none', cursor: 'pointer' }}>⋯</button>
      </div>
      <div style={{ padding: '0 20px 16px' }}>
        <p style={{ fontSize: '15px', color: theme.text || '#111827', lineHeight: '1.6', marginBottom: '12px' }}>
          Just launched our new design system! 🎨 Check out the comprehensive component library we've been working on. Link in bio! #design #ui #ux
        </p>
      </div>
      <img src="https://images.unsplash.com/photo-1561070791-2526d30994b5" alt="Post" style={{ width: '100%', maxHeight: '300px', objectFit: 'cover' as const }} />
      <div style={{ padding: '16px 20px', display: 'flex', gap: '24px', borderTop: '1px solid #e5e7eb', fontSize: '14px' }}>
        <button onClick={(e) => { e.stopPropagation(); setLiked(!liked); setLikes(liked ? likes - 1 : likes + 1); }} style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', color: liked ? '#ef4444' : '#6b7280' }}>
          <span style={{ fontSize: '18px' }}>{liked ? '❤️' : '🤍'}</span>
          <span>{likes}</span>
        </button>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', color: '#6b7280' }}><span style={{ fontSize: '18px' }}>💬</span><span>45</span></button>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '8px', color: '#6b7280' }}><span style={{ fontSize: '18px' }}>🔄</span><span>12</span></button>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', marginLeft: 'auto', fontSize: '18px', color: '#6b7280' }}>📤</button>
      </div>
    </div>
  );
};
