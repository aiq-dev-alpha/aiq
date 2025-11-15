import React, { useState } from 'react';

interface AccordionItem {
  id: string;
  title: string;
  content: string;
  icon?: string;
}

export interface ComponentProps {
  items?: AccordionItem[];
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  allowMultiple?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { id: '1', title: 'Section 1', content: 'Content 1', icon: '📄' },
    { id: '2', title: 'Section 2', content: 'Content 2', icon: '📋' },
    { id: '3', title: 'Section 3', content: 'Content 3', icon: '📝' }
  ],
  theme = {},
  className = '',
  allowMultiple = false
}) => {
  const [activeIds, setActiveIds] = useState<Set<string>>(new Set());
  const primary = theme.primary || '#2563eb';
  const background = theme.background || '#ecfdf5';

  const toggleItem = (id: string) => {
    const newIds = new Set(activeIds);
    if (newIds.has(id)) {
      newIds.delete(id);
    } else {
      if (!allowMultiple) {
        newIds.clear();
      }
      newIds.add(id);
    }
    setActiveIds(newIds);
  };

  return (
    <div className={className} style={{ width: '100%', maxWidth: '700px' }}>
      {items.map(item => {
        const isActive = activeIds.has(item.id);
        return (
          <div
            key={item.id}
            style={{
              marginBottom: '10px',
              borderRadius: '22px',
              overflow: 'hidden',
              boxShadow: isActive ? '0 12px 26px rgba(16,185,129,0.25)' : '0 1px 3px rgba(0,0,0,0.1)',
              transition: 'all 0.3s ease-in-out'
            }}
          >
            <button
              onClick={() => toggleItem(item.id)}
              style={{
                width: '100%',
                padding: '22px 30px',
                backgroundColor: isActive ? primary : '#fff',
                color: isActive ? '#fff' : '#1f2937',
                border: 'none',
                cursor: 'pointer',
                textAlign: 'left',
                fontWeight: '900',
                fontSize: '18px',
                display: 'flex',
                alignItems: 'center',
                gap: '20px',
                transition: 'all 0.3s ease-in-out'
              }}
            >
              <span style={{ fontSize: '18px' }}> {item.icon}</span>
              <span style={{ flex: 1 }}> {item.title}</span>
              <span style={{
                transform: isActive ? 'rotate(180deg)' : 'rotate(0deg)',
                transition: 'transform 0.3s'
              }}>▾</span>
            </button>
            <div style={{
              maxHeight: isActive ? '1000px' : '0',
              overflow: 'hidden',
              transition: 'max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
              backgroundColor: background
            }}>
              <div style={{
                padding: isActive ? '26px 30px' : '0 30px',
                color: '#4b5563',
                lineHeight: '1.6',
                transition: 'padding 0.3s'
              }}>
                {item.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};