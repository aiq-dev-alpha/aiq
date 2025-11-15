// Variant 17: Recipe card with ingredients list
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isSaved, setIsSaved] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  const ingredients = ['2 cups flour', '1 cup sugar', '3 eggs', '1 tsp vanilla'];

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'scale(1)' : 'scale(0.95)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '16px',
        overflow: 'hidden',
        boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)',
        cursor: 'pointer',
        width: '320px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ position: 'relative' as const, height: '180px', overflow: 'hidden' }}>
        <img
          src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445"
          alt="Recipe"
          style={{ width: '100%', height: '100%', objectFit: 'cover' as const, transition: 'transform 400ms ease', transform: isHovered ? 'scale(1.1)' : 'scale(1)' }}
        />
        <div style={{
          position: 'absolute' as const,
          top: '12px',
          left: '12px',
          padding: '6px 12px',
          backgroundColor: '#10b981',
          color: '#ffffff',
          borderRadius: '8px',
          fontSize: '12px',
          fontWeight: '700',
        }}>
          30 min
        </div>
        <button
          onClick={(e) => { e.stopPropagation(); setIsSaved(!isSaved); }}
          style={{
            position: 'absolute' as const,
            top: '12px',
            right: '12px',
            width: '36px',
            height: '36px',
            borderRadius: '50%',
            border: 'none',
            backgroundColor: 'rgba(255,255,255,0.95)',
            cursor: 'pointer',
            fontSize: '18px',
          }}
        >
          {isSaved ? '❤️' : '🤍'}
        </button>
      </div>
      <div style={{ padding: '20px' }}>
        <h3 style={{ fontSize: '20px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '12px' }}>
          Classic Chocolate Cake
        </h3>
        <div style={{ marginBottom: '16px' }}>
          <div style={{ fontSize: '13px', fontWeight: '600', color: theme.text || '#111827', marginBottom: '8px', textTransform: 'uppercase' as const, letterSpacing: '0.5px' }}>
            Ingredients
          </div>
          <ul style={{ margin: 0, paddingLeft: '20px', fontSize: '13px', color: '#6b7280', lineHeight: '1.8' }}>
            {ingredients.map((ing, i) => (
              <li key={i}>{ing}</li>
            ))}
          </ul>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px', fontSize: '13px', color: '#6b7280' }}>
          <span>⭐ 4.8 (245)</span>
          <span>👨‍🍳 Easy</span>
          <span>🍴 8 servings</span>
        </div>
      </div>
    </div>
  );
};
