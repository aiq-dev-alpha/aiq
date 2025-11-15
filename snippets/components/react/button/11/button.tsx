import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [expanded, setExpanded] = useState(false);
  const primary = theme.primary || '#f97316';

  return (
    <button
      className={className}
      onClick={() => { setExpanded(!expanded); onInteract?.('expand'); }}
      style={{
        padding: expanded ? '20px 80px' : '12px 24px',
        background: primary,
        color: '#fff',
        border: 'none',
        borderRadius: expanded ? '24px' : '8px',
        fontSize: expanded ? '20px' : '14px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 400ms cubic-bezier(0.68, -0.55, 0.265, 1.55)',
        outline: 'none',
        whiteSpace: 'nowrap'
      }}
    >
      {expanded ? 'Expanded!' : 'Click to Expand'}
    </button>
  );
};