import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [isHovered, setIsHovered] = useState(false);
  const primary = theme.primary || '#10b981';
  const background = theme.background || '#ffffff';

  return (
    <div
      className={className}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={() => onInteract?.('click')}
      style={{
        padding: '28px',
        backgroundColor: background,
        border: 'none',
        borderRadius: '8px',
        boxShadow: isHovered 
          ? '0 20px 40px rgba(0,0,0,0.15)'
          : '0 4px 12px rgba(0,0,0,0.08)',
        transform: isHovered ? 'translateY(-4px)' : 'translateY(0)',
        transition: 'all 250ms ease',
        cursor: 'pointer'
      }}
    >
      <div style={{ width: '40px', height: '4px', backgroundColor: primary, borderRadius: '2px', marginBottom: '16px' }} />
      <h3 style={{ margin: '0 0 8px 0', fontSize: '20px', fontWeight: 700 }}>Featured Card</h3>
      <p style={{ margin: 0, fontSize: '15px', color: '#6b7280', lineHeight: 1.6 }}>Elevated card with hover effect</p>
    </div>
  );
};
