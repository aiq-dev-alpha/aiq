// Variant 42: Carousel card
import React, { useState, useEffect } from 'react';
export interface CardProps { theme?: { primary?: string; background?: string; text?: string }; className?: string; onHover?: (isHovered: boolean) => void; }
export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [currentSlide, setCurrentSlide] = useState(0);
  useEffect(() => { setIsVisible(true); }, []);
  const slides = [
    { title: 'Summer Collection', desc: 'Discover our latest styles', bg: '#fbbf24' },
    { title: 'New Arrivals', desc: 'Fresh looks for the season', bg: '#10b981' },
    { title: 'Sale Items', desc: 'Up to 50% off selected items', bg: '#ef4444' }
  ];
  const nextSlide = () => setCurrentSlide((currentSlide + 1) % slides.length);
  const prevSlide = () => setCurrentSlide((currentSlide - 1 + slides.length) % slides.length);
  return (
    <div className={className} style={{ opacity: isVisible ? 1 : 0, transform: isVisible ? 'scale(1)' : 'scale(0.95)', transition: 'all 300ms ease', backgroundColor: theme.background || '#ffffff', borderRadius: '16px', overflow: 'hidden', boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.15)' : '0 6px 16px rgba(0,0,0,0.08)', cursor: 'pointer', width: '380px' }} onMouseEnter={() => { setIsHovered(true); onHover?.(true); }} onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}>
      <div style={{ position: 'relative' as const, height: '240px', overflow: 'hidden' }}>
        {slides.map((slide, i) => (
          <div key={i} style={{ position: 'absolute' as const, top: 0, left: 0, width: '100%', height: '100%', backgroundColor: slide.bg, display: 'flex', flexDirection: 'column' as const, alignItems: 'center', justifyContent: 'center', opacity: currentSlide === i ? 1 : 0, transition: 'opacity 500ms ease', transform: currentSlide === i ? 'scale(1)' : 'scale(0.9)' }}>
            <h3 style={{ fontSize: '28px', fontWeight: 'bold', color: '#ffffff', marginBottom: '12px', textAlign: 'center' as const }}>{slide.title}</h3>
            <p style={{ fontSize: '16px', color: 'rgba(255,255,255,0.95)' }}>{slide.desc}</p>
          </div>
        ))}
        <button onClick={(e) => { e.stopPropagation(); prevSlide(); }} style={{ position: 'absolute' as const, top: '50%', left: '16px', transform: 'translateY(-50%)', width: '40px', height: '40px', borderRadius: '50%', border: 'none', backgroundColor: 'rgba(255,255,255,0.9)', cursor: 'pointer', fontSize: '18px' }}>←</button>
        <button onClick={(e) => { e.stopPropagation(); nextSlide(); }} style={{ position: 'absolute' as const, top: '50%', right: '16px', transform: 'translateY(-50%)', width: '40px', height: '40px', borderRadius: '50%', border: 'none', backgroundColor: 'rgba(255,255,255,0.9)', cursor: 'pointer', fontSize: '18px' }}>→</button>
        <div style={{ position: 'absolute' as const, bottom: '16px', left: '50%', transform: 'translateX(-50%)', display: 'flex', gap: '8px' }}>
          {slides.map((_, i) => (
            <button key={i} onClick={(e) => { e.stopPropagation(); setCurrentSlide(i); }} style={{ width: '8px', height: '8px', borderRadius: '50%', border: 'none', backgroundColor: currentSlide === i ? '#ffffff' : 'rgba(255,255,255,0.5)', cursor: 'pointer' }} />
          ))}
        </div>
      </div>
      <div style={{ padding: '20px' }}>
        <button style={{ width: '100%', padding: '12px', borderRadius: '10px', border: 'none', backgroundColor: theme.primary || '#3b82f6', color: '#ffffff', fontSize: '15px', fontWeight: '600', cursor: 'pointer' }}>
          Shop Now
        </button>
      </div>
    </div>
  );
};
