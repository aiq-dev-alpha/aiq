import React, { useState } from 'react';

export interface ComponentProps {
  items?: { id: string; title: string; content: string }[];
  allowMultiple?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { id: '1', title: 'Item 1', content: 'Content 1' },
    { id: '2', title: 'Item 2', content: 'Content 2' },
    { id: '3', title: 'Item 3', content: 'Content 3' }
  ],
  allowMultiple = false,
  theme = {},
  className = ''
}) => {
  const [openItems, setOpenItems] = useState<Set<string>>(new Set());
  const primary = theme.primary || '#10b981';

  const toggleItem = (id: string) => {
    const newOpenItems = new Set(openItems);
    if (newOpenItems.has(id)) {
      newOpenItems.delete(id);
    } else {
      if (!allowMultiple) {
        newOpenItems.clear();
      }
      newOpenItems.add(id);
    }
    setOpenItems(newOpenItems);
  };

  return (
    <div className={className} style={{ width: '100%', maxWidth: '700px', margin: '0 auto' }}>
      {items.map((item) => {
        const isOpen = openItems.has(item.id);
        return (
          <div key={item.id} style={{ borderBottom: '1px solid #e5e7eb' }}>
            <button
              onClick={() => toggleItem(item.id)}
              style={{
                width: '100%',
                padding: '16px 24px',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                textAlign: 'left',
                border: 'none',
                backgroundColor: isOpen ? '#f9fafb' : '#fff',
                cursor: 'pointer',
                transition: 'background-color 0.2s'
              }}
            >
              <span style={{ fontWeight: '600', color: '#1f2937' }}>{item.title}</span>
              <span style={{ transform: isOpen ? 'rotate(180deg)' : 'none', transition: 'transform 0.3s', color: primary }}>
                ▼
              </span>
            </button>
            <div
              style={{
                maxHeight: isOpen ? '300px' : '0',
                overflow: 'hidden',
                transition: 'max-height 0.3s ease'
              }}
            >
              <div style={{ padding: '16px 24px', color: '#4b5563', backgroundColor: '#f9fafb' }}>
                {item.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};