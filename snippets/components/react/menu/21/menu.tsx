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
  const primary = theme.primary || '#ef4444';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '2px solid #e5e7eb',
        borderRadius: '12px',
        boxShadow: '0 8px 20px rgba(0,0,0,0.15)',
        padding: '10px',
        minWidth: '240px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '14px 24px',
            borderRadius: '12px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            backgroundColor: hoveredIdx === idx ? '#fef2f2' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.2s',
            marginBottom: idx < items.length - 1 ? '8px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '18px' }}> {item.icon}</span>}
          <span style={{ fontSize: '14px', fontWeight: '600' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};