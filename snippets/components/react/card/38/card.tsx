// Variant 38: Music track card with player
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const [progress, setProgress] = useState(45);
  useEffect(() => { setIsVisible(true); }, []);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', display: 'flex', gap: '20px', padding: '20px', background: 'linear-gradient(135deg, #1e293b 0%, #334155 100%)', borderRadius: '16px', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.3)' : '0 8px 20px rgba(0,0,0,0.2)', cursor: 'pointer', width: '380px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <img src="https://images.unsplash.com/photo-1470225620780-dba8ba36b745" alt="Album" style={{ width: '100px', height: '100px', borderRadius: '12px', objectFit: 'cover' as const, boxShadow: '0 4px 12px rgba(0,0,0,0.3)' }} />
      <div style={{ flex: 1 }}>
        <h4 style={{ fontSize: '17px', fontWeight: 'bold', color: '#ffffff', marginBottom: '4px' }}>Midnight Dreams</h4>
        <div style={{ fontSize: '13px', color: '#94a3b8', marginBottom: '16px' }}>The Synthwave Collective</div>
        <div style={{ marginBottom: '12px' }}>
          <div style={{ width: '100%', height: '4px', backgroundColor: '#334155', borderRadius: '2px', overflow: 'hidden' }}>
            <div style={{ width: `${progress}%`, height: '100%', backgroundColor: theme.primary || '#3b82f6', transition: 'width 300ms ease' }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', color: '#64748b', marginTop: '6px' }}>
            <span>1:45</span>
            <span>3:52</span>
          </div>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <button style={{ width: '32px', height: '32px', borderRadius: '50%', border: 'none', backgroundColor: '#334155', color: '#ffffff', fontSize: '14px', cursor: 'pointer' }}>⏮</button>
          <button onClick={(e) => { e.stopPropagation(); setIsPlaying(!isPlaying); }} style={{ width: '40px', height: '40px', borderRadius: '50%', border: 'none', backgroundColor: theme.primary || '#3b82f6', color: '#ffffff', fontSize: '18px', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {isPlaying ? '⏸' : '▶'}
          </button>
          <button style={{ width: '32px', height: '32px', borderRadius: '50%', border: 'none', backgroundColor: '#334155', color: '#ffffff', fontSize: '14px', cursor: 'pointer' }}>⏭</button>
          <button style={{ marginLeft: 'auto', background: 'none', border: 'none', color: '#94a3b8', fontSize: '16px', cursor: 'pointer' }}>🔊</button>
        </div>
      </div>
    </div>
  );
};
