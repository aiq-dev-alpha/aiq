import React, { useState } from 'react';

interface AccordionItem {
  id: string;
  header: React.ReactNode;
  content: React.ReactNode;
  icon?: React.ReactNode;
}

interface AccordionProps {
  items: AccordionItem[];
  defaultOpen?: string[];
}

export const Accordion: React.FC<AccordionProps> = ({
  items,
  defaultOpen = []
}) => {
  const [openIds, setOpenIds] = useState<Set<string>>(new Set(defaultOpen));

  const toggle = (id: string) => {
    const newSet = new Set(openIds);
    if (newSet.has(id)) {
      newSet.delete(id);
    } else {
      newSet.add(id);
    }
    setOpenIds(newSet);
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
      {items.map((item) => {
        const isOpen = openIds.has(item.id);
        return (
          <div
            key={item.id}
            style={{
              background: '#fff',
              borderRadius: '12px',
              boxShadow: isOpen
                ? '0 4px 12px rgba(0,0,0,0.1)'
                : '0 2px 4px rgba(0,0,0,0.05)',
              transition: 'all 0.3s ease',
              overflow: 'hidden'
            }}
          >
            <button
              onClick={() => toggle(item.id)}
              style={{
                width: '100%',
                padding: '18px 20px',
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                background: isOpen ? '#f9fafb' : 'transparent',
                border: 'none',
                cursor: 'pointer',
                transition: 'background 0.2s'
              }}
            >
              {item.icon && <span style={{ fontSize: '20px' }}>{item.icon}</span>}
              <span style={{ flex: 1, textAlign: 'left', fontWeight: 500, fontSize: '15px' }}>
                {item.header}
              </span>
              <span
                style={{
                  width: '24px',
                  height: '24px',
                  borderRadius: '50%',
                  background: isOpen ? '#3b82f6' : '#e5e7eb',
                  color: isOpen ? '#fff' : '#666',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '12px',
                  transition: 'all 0.3s'
                }}
              >
                {isOpen ? '−' : '+'}
              </span>
            </button>
            <div
              style={{
                maxHeight: isOpen ? '1000px' : '0',
                overflow: 'hidden',
                transition: 'max-height 0.4s ease'
              }}
            >
              <div style={{ padding: '0 20px 20px 20px', color: '#555', lineHeight: '1.6' }}>
                {item.content}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
