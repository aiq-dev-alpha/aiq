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
  const primary = theme.primary || '#8b5cf6';
  const background = theme.background || '#faf5ff';

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
              marginBottom: '12px',
              borderRadius: '6px',
              overflow: 'hidden',
              boxShadow: isActive ? '0 8px 24px rgba(139,92,246,0.2)' : '0 2px 8px rgba(0,0,0,0.08)',
              transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
            }}
          >
            <button
              onClick={() => toggleItem(item.id)}
              style={{
                width: '100%',
                padding: '8px 12px',
                backgroundColor: isActive ? primary : '#fff',
                color: isActive ? '#fff' : '#1f2937',
                border: 'none',
                cursor: 'pointer',
                textAlign: 'left',
                fontWeight: '600',
                fontSize: '16px',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                transition: 'all 0.3s'
              }}
            >
              <span style={{ fontSize: '24px' }}> {item.icon}</span>
              <span style={{ flex: 1 }}> {item.title}</span>
              <span style={{
                transform: isActive ? 'rotate(180deg)' : 'rotate(0deg)',
                transition: 'transform 0.3s'
              }}>▼</span>
            </button>
            <div style={{
              maxHeight: isActive ? '1000px' : '0',
              overflow: 'hidden',
              transition: 'max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
              backgroundColor: background
            }}>
              <div style={{
                padding: isActive ? '20px 24px' : '0 24px',
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