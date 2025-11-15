import React, { useState } from 'react';

interface Tab {
  id: string;
  label: string;
  content: string;
}

export interface ComponentProps {
  tabs?: Tab[];
  theme?: { primary?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  tabs = [
    { id: '1', label: 'Tab 1', content: 'Content 1' },
    { id: '2', label: 'Tab 2', content: 'Content 2' },
    { id: '3', label: 'Tab 3', content: 'Content 3' }
  ],
  theme = {},
  className = ''
}) => {
  const [activeTab, setActiveTab] = useState(tabs[0]?.id);
  const primary = theme.primary || '#ec4899';
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '600px' }}>
      <div style={{ display: 'flex', gap: '2px', borderBottom: '2px solid #e5e7eb' }}>
        {tabs.map(tab => {
          const isActive = tab.id === activeTab;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              style={{
                padding: '13px 17px',
                backgroundColor: 'transparent',
                border: 'none',
                borderBottom: isActive ? `3px solid ${primary}` : '3px solid transparent',
                color: isActive ? primary : '#6b7280',
                cursor: 'pointer',
                fontWeight: isActive ? '600' : '500',
                fontSize: '15px',
                transition: 'all 0.2s ease'
              }}
            >
              {tab.label}
            </button>
          );
        })}
      </div>
      <div style={{ padding: '28px 0', color: '#374151', lineHeight: '1.7' }}>
        {tabs.find(t => t.id === activeTab)?.content}
      </div>
    </div>
  );
};