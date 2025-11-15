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
  const primary = theme.primary || '#14b8a6';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '2px solid #14b8a6',
        borderRadius: '22px',
        boxShadow: '0 14px 32px rgba(0,0,0,0.28)',
        padding: '11px',
        minWidth: '230px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '14px 20px',
            borderRadius: '22px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '14px',
            backgroundColor: hoveredIdx === idx ? '#f0fdfa' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
            marginBottom: idx < items.length - 1 ? '7px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '18px' }}> {item.icon}</span>}
          <span style={{ fontSize: '18px', fontWeight: '800' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};