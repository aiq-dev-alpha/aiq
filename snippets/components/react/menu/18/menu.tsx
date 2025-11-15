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
  const primary = theme.primary || '#f59e0b';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '1px solid #f59e0b',
        borderRadius: '10px',
        boxShadow: '0 3px 10px rgba(0,0,0,0.09)',
        padding: '6px',
        minWidth: '180px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '12px 20px',
            borderRadius: '10px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            backgroundColor: hoveredIdx === idx ? '#fffbeb' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.2s',
            marginBottom: idx < items.length - 1 ? '3px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '18px' }}> {item.icon}</span>}
          <span style={{ fontSize: '14px', fontWeight: '500' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};