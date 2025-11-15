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
  const primary = theme.primary || '#10b981';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: '#fff',
        border: '2px solid #10b981',
        borderRadius: '16px',
        boxShadow: '0 6px 16px rgba(0,0,0,0.18)',
        padding: '12px',
        minWidth: '220px'
      }}
    >
      {items.map((item, idx) => (
        <div
          key={idx}
          onClick={item.onClick}
          onMouseEnter={() => setHoveredIdx(idx)}
          onMouseLeave={() => setHoveredIdx(null)}
          style={{
            padding: '20px 24px',
            borderRadius: '16px',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            gap: '20px',
            backgroundColor: hoveredIdx === idx ? '#ecfdf5' : 'transparent',
            color: hoveredIdx === idx ? primary : '#374151',
            transition: 'all 0.35s ease-in-out',
            marginBottom: idx < items.length - 1 ? '6px' : '0'
          }}
        >
          {item.icon && <span style={{ fontSize: '16px' }}> {item.icon}</span>}
          <span style={{ fontSize: '16px', fontWeight: '700' }}>{item.label}</span>
        </div>
      ))}
    </div>
  );
};