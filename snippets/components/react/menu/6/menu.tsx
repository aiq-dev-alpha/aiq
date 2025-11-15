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
  const primary = theme.primary || '#3b82f6';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '1px solid #e5e7eb',
        borderRadius: '6px',
        boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
        padding: '8px',
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
            padding: '8px 12px',
            borderRadius: '6px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            backgroundColor: hoveredIdx === idx ? '#eff6ff' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.2s',
            marginBottom: idx < items.length - 1 ? '4px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '18px' }}> {item.icon}</span>}
          <span style={{ fontSize: '14px', fontWeight: '500' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};