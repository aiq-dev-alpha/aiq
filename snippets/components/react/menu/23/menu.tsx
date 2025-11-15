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
  const primary = theme.primary || '#8b5cf6';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '1px solid #8b5cf6',
        borderRadius: '8px',
        boxShadow: '0 2px 4px rgba(0,0,0,0.06)',
        padding: '9px',
        minWidth: '210px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '12px 16px',
            borderRadius: '8px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            backgroundColor: hoveredIdx === idx ? '#faf5ff' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.35s ease-in-out',
            marginBottom: idx < items.length - 1 ? '5px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '16px' }}> {item.icon}</span>}
          <span style={{ fontSize: '16px', fontWeight: '700' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};