import React, { useState } from 'react';

interface AccordionItem {
  id: string;
  title: string;
  content: string;
}

export interface ComponentProps {
  items?: AccordionItem[];
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { id: '1', title: 'Section 1', content: 'Content 1' },
    { id: '2', title: 'Section 2', content: 'Content 2' },
    { id: '3', title: 'Section 3', content: 'Content 3' }
  ],
  theme = {},
  className = ''
}) => {
  const [activeId, setActiveId] = useState<string | null>(null);
  const primary = theme.primary || '#3b82f6';

  return (
    <div className={className} style={{ width: '100%', maxWidth: '600px' }}>
      {items.map(item => {
        const isActive = activeId === item.id;
        return (
          <div key={item.id} style={{ marginBottom: '8px' }}>
            <button
              onClick={() => setActiveId(isActive ? null : item.id)}
              style={{
                width: '100%',
                padding: '16px',
                backgroundColor: isActive ? primary : '#fff',
                color: isActive ? '#fff' : '#111',
                border: `1px solid ${primary}`,
                borderRadius: '8px',
                cursor: 'pointer',
                textAlign: 'left',
                fontWeight: '500',
                transition: 'all 0.2s'
              }}
            >
              {item.title}
            </button>
            <div style={{
              maxHeight: isActive ? '500px' : '0',
              overflow: 'hidden',
              transition: 'max-height 0.3s ease',
              backgroundColor: '#f9fafb',
              borderLeft: `3px solid ${primary}`,
              marginLeft: '8px'
            }}>
              <div style={{ padding: isActive ? '16px' : '0 16px' }}>
                {item.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};