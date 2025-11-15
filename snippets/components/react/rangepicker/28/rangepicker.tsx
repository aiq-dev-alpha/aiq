import React, { useState } from 'react';

export interface ComponentProps {
  title?: string;
  content?: React.ReactNode;
  expandable?: boolean;
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (expanded: boolean) => void;
}

export const Component: React.FC<ComponentProps> = ({
  title = 'Expandable Card',
  content = 'This is the expandable content that appears when you click the card.',
  expandable = true,
  theme = {},
  className = '',
  onInteract
}) => {
  const [expanded, setExpanded] = useState(false);
  const primary = theme.primary || '#f59e0b';

  const toggleExpand = () => {
    if (!expandable) return;
    const newState = !expanded;
    setExpanded(newState);
    onInteract?.(newState);
  };

  return (
    <div className={className} style={{ border: \`2px solid \${expanded ? primary : '#e5e7eb'}\`, borderRadius: '12px', overflow: 'hidden', maxWidth: '500px', transition: 'all 300ms ease' }}>
      <div
        onClick={toggleExpand}
        style={{
          padding: '20px',
          background: expanded ? \`\${primary}10\` : '#fff',
          cursor: expandable ? 'pointer' : 'default',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          transition: 'all 200ms ease'
        }}
      >
        <h3 style={{ margin: 0, fontSize: '18px', fontWeight: 700, color: expanded ? primary : '#1f2937' }}>{title}</h3>
        {expandable && (
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none" style={{ transform: expanded ? 'rotate(180deg)' : 'rotate(0)', transition: 'transform 300ms ease' }}>
            <path d="M5 7.5L10 12.5L15 7.5" stroke={expanded ? primary : '#6b7280'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
      </div>
      <div style={{ maxHeight: expanded ? '1000px' : '0', overflow: 'hidden', transition: 'max-height 400ms ease' }}>
        <div style={{ padding: '20px', borderTop: \`1px solid \${primary}20\`, fontSize: '15px', lineHeight: '1.6', color: '#4b5563' }}>
          {content}
        </div>
      </div>
    </div>
  );
};