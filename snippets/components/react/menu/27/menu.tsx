import React, { useState } from 'react';

interface MenuItem {
  label: string;
  onClick?: () => void;
  icon?: string;
}

export interface ComponentProps {
  items?: MenuItem[];
  theme?: { primary?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { label: 'Profile', icon: '👤' },
    { label: 'Settings', icon: '⚙️' },
    { label: 'Logout', icon: '🚪' }
  ],
  theme = {},
  className = ''
}) => {
  const [hoveredIdx, setHoveredIdx] = useState<number | null>(null);
  const primary = theme.primary || '#ec4899';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '1px solid #e5e7eb',
        borderRadius: '22px',
        boxShadow: '0 16px 30px rgba(0,0,0,0.22)',
        padding: '14px',
        minWidth: '200px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '22px 30px',
            borderRadius: '22px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '20px',
            backgroundColor: hoveredIdx === idx ? '#fdf2f8' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.3s ease-in-out',
            marginBottom: idx < items.length - 1 ? '10px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '18px' }}> {item.icon}</span>}
          <span style={{ fontSize: '18px', fontWeight: '900' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};