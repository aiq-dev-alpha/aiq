import React, { useState } from 'react';

export interface ComponentProps {
  items?: { id: string; title: string; content: string; icon?: string }[];
  variant?: 'default' | 'bordered' | 'shadow';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { id: '1', title: 'Section 1', content: 'Content for section 1', icon: '📄' },
    { id: '2', title: 'Section 2', content: 'Content for section 2', icon: '📋' },
    { id: '3', title: 'Section 3', content: 'Content for section 3', icon: '📝' }
  ],
  variant = 'default',
  theme = {},
  className = ''
}) => {
  const [activeId, setActiveId] = useState<string | null>(null);
  const primary = theme.primary || '#3b82f6';

  const variantStyles = {
    default: { border: 'none', borderRadius: '0', boxShadow: 'none' },
    bordered: { border: `2px solid ${primary}`, borderRadius: '8px', boxShadow: 'none' },
    shadow: { border: 'none', borderRadius: '8px', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }
  };

  const style = variantStyles[variant];

  return (
    <div className={className} style={{ width: '100%', maxWidth: '800px', margin: '0 auto', display: 'flex', flexDirection: 'column', gap: '12px' }}>
      {items.map((item) => {
        const isActive = activeId === item.id;
        return (
          <div key={item.id} style={{ ...style, backgroundColor: '#fff', overflow: 'hidden', transition: 'all 0.2s' }}>
            <button
              onClick={() => setActiveId(isActive ? null : item.id)}
              style={{
                width: '100%',
                padding: '16px 20px',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                textAlign: 'left',
                border: 'none',
                backgroundColor: 'transparent',
                cursor: 'pointer',
                transition: 'background-color 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f0f9ff'}
              onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
            >
              {item.icon && <span style={{ fontSize: '20px', color: primary }}>{item.icon}</span>}
              <span style={{ flex: 1, fontWeight: '500', color: '#1f2937' }}>{item.title}</span>
              <span style={{ fontSize: '24px', color: primary, transform: isActive ? 'rotate(45deg)' : 'none', transition: 'transform 0.2s' }}>
                +
              </span>
            </button>
            {isActive && (
              <div style={{ padding: '16px 20px', borderTop: '1px solid #e5e7eb', backgroundColor: '#f0f9ff' }}>
                <p style={{ margin: 0, color: '#4b5563', lineHeight: '1.6' }}>{item.content}</p>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};