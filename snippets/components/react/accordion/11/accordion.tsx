import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [expanded, setExpanded] = useState(false);
  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  return (
    <div className={className} style={{ border: '1px solid #e5e7eb', borderRadius: '8px', overflow: 'hidden' }}>
      <button onClick={() => { setExpanded(!expanded); onInteract?.('toggle'); }} style={{ width: '100%', padding: '16px', backgroundColor: background, border: 'none', display: 'flex', alignItems: 'center', justifyContent: 'space-between', cursor: 'pointer', fontSize: '15px', fontWeight: 600 }}>
        <span>Accordion Item</span>
        <span style={{ transform: expanded ? 'rotate(180deg)' : 'rotate(0)', transition: 'transform 200ms' }}>▼</span>
      </button>
      {expanded && <div style={{ padding: '16px', backgroundColor: '#f9fafb', borderTop: `1px solid ${primary}20`, fontSize: '14px', color: '#6b7280' }}>Accordion content</div>}
    </div>
  );
};
