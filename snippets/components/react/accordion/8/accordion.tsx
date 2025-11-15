import React, { useState } from 'react';

interface AccordionItem {
  title: string;
  content: React.ReactNode;
}

interface AccordionProps {
  items: AccordionItem[];
  allowMultiple?: boolean;
  bordered?: boolean;
}

export const Accordion: React.FC<AccordionProps> = ({
  items,
  allowMultiple = false,
  bordered = true
}) => {
  const [openIndexes, setOpenIndexes] = useState<Set<number>>(new Set());

  const toggleItem = (index: number) => {
    const newSet = new Set(openIndexes);
    if (newSet.has(index)) {
      newSet.delete(index);
    } else {
      if (!allowMultiple) {
        newSet.clear();
      }
      newSet.add(index);
    }
    setOpenIndexes(newSet);
  };

  return (
    <div style={{ width: '100%' }}>
      {items.map((item, index) => {
        const isOpen = openIndexes.has(index);
        return (
          <div
            key={index}
            style={{
              borderBottom: bordered ? '1px solid #e5e7eb' : 'none',
              marginBottom: bordered ? 0 : '8px'
            }}
          >
            <button
              onClick={() => toggleItem(index)}
              style={{
                width: '100%',
                padding: '16px',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                background: 'transparent',
                border: 'none',
                cursor: 'pointer',
                fontSize: '16px',
                fontWeight: 600,
                textAlign: 'left',
                color: '#111',
                transition: 'all 0.2s'
              }}
            >
              <span>{item.title}</span>
              <span
                style={{
                  transform: isOpen ? 'rotate(180deg)' : 'rotate(0)',
                  transition: 'transform 0.3s ease'
                }}
              >
                ▼
              </span>
            </button>
            <div
              style={{
                maxHeight: isOpen ? '500px' : '0',
                overflow: 'hidden',
                transition: 'max-height 0.3s ease'
              }}
            >
              <div style={{ padding: '0 16px 16px 16px', color: '#666', lineHeight: '1.6' }}>
                {item.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
