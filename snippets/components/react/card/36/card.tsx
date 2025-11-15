import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [hovered, setHovered] = useState(false);
  const primary = theme.primary || '#eab308';
  const text = theme.text || '#1f2937';
  
  return (
    <div
      className={className}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
      onClick={() => onInteract?.('testimonial')}
      style={{
        width: '340px',
        padding: '28px',
        background: '#ffffff',
        border: `2px solid ${hovered ? primary : '#e5e7eb'}`,
        borderRadius: '14px',
        cursor: 'pointer',
        transition: 'all 300ms ease',
        boxShadow: hovered ? `0 12px 32px ${primary}30` : '0 4px 16px rgba(0,0,0,0.08)',
        transform: hovered ? 'translateY(-6px)' : 'translateY(0)'
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '16px' }}>
        <div style={{
          width: '48px',
          height: '48px',
          borderRadius: '12px',
          background: `${primary}20`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '24px',
          fontWeight: 700,
          color: primary
        }}>
          T
        </div>
        <h3 style={{ margin: 0, color: text, fontSize: '20px', fontWeight: 700 }}>
          Testimonial
        </h3>
      </div>
      <p style={{ margin: 0, color: '#64748b', fontSize: '15px', lineHeight: 1.7 }}>
        This is a testimonial component with custom styling and hover effects.
      </p>
    </div>
  );
};