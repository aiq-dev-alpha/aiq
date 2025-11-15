// Variant 16: Article card with category tags
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  const tags = ['React', 'TypeScript', 'WebDev'];

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        padding: '28px',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '14px',
        boxShadow: isHovered ? '0 14px 28px rgba(0,0,0,0.12)' : '0 5px 14px rgba(0,0,0,0.07)',
        cursor: 'pointer',
        width: '340px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{ display: 'flex', flexWrap: 'wrap' as const, gap: '8px', marginBottom: '16px' }}>
        {tags.map((tag, i) => (
          <span key={i} style={{
            padding: '5px 12px',
            backgroundColor: `${theme.primary || '#3b82f6'}15`,
            color: theme.primary || '#3b82f6',
            borderRadius: '6px',
            fontSize: '12px',
            fontWeight: '600',
          }}>
            #{tag}
          </span>
        ))}
      </div>
      <h3 style={{ fontSize: '22px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '12px', lineHeight: '1.3' }}>
        Modern React Patterns for 2024
      </h3>
      <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.7', marginBottom: '20px' }}>
        Explore the latest patterns and best practices for building scalable React applications with TypeScript.
      </p>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', paddingTop: '16px', borderTop: '1px solid #e5e7eb' }}>
        <div style={{ fontSize: '13px', color: '#9ca3af' }}>Dec 10, 2024  •  12 min read</div>
        <div style={{ fontSize: '13px', color: theme.primary || '#3b82f6', fontWeight: '600' }}>Continue reading →</div>
      </div>
    </div>
  );
};
