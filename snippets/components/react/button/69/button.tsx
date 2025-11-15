import React, { useState } from 'react';

export interface ComponentProps {
  tabs?: Array<{ id: string; label: string; content: React.ReactNode }>;
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (tabId: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  tabs = [
    { id: '1', label: 'Tab 1', content: 'Content 1' },
    { id: '2', label: 'Tab 2', content: 'Content 2' },
    { id: '3', label: 'Tab 3', content: 'Content 3' }
  ],
  theme = {},
  className = '',
  onInteract
}) => {
  const [activeTab, setActiveTab] = useState(tabs[0]?.id || '');
  const primary = theme.primary || '#6366f1';

  return (
    <div className={className} style={{ maxWidth: '600px' }}>
      <div style={{ display: 'flex', gap: '4px', borderBottom: \`2px solid \${primary}20\` }}>
        {tabs.map(tab => (
          <button
            key={tab.id}
            onClick={() => { setActiveTab(tab.id); onInteract?.(tab.id); }}
            style={{
              padding: '12px 24px',
              background: 'transparent',
              border: 'none',
              borderBottom: \`3px solid \${activeTab === tab.id ? primary : 'transparent'}\`,
              color: activeTab === tab.id ? primary : '#6b7280',
              fontWeight: activeTab === tab.id ? 700 : 500,
              cursor: 'pointer',
              transition: 'all 200ms ease',
              marginBottom: '-2px'
            }}
          >
            {tab.label}
          </button>
        ))}
      </div>
      <div style={{ padding: '24px 0' }}>
        {tabs.find(t => t.id === activeTab)?.content}
      </div>
    </div>
  );
};