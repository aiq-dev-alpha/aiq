import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [expanded, setExpanded] = useState(false);
  const primary = theme.primary || '#3b82f6';
  const bg = theme.background || '#ffffff';
  
  return (
  <div
  className={className}
  onClick={() => { setExpanded(!expanded); onInteract?.('expand'); }}
  style={{
  padding: expanded ? '32px' : '20px',
  background: bg,
  border: `2px solid ${primary}20`,
  borderRadius: '16px',
  cursor: 'pointer',
  transition: 'all 400ms cubic-bezier(0.34, 1.56, 0.64, 1)',
  boxShadow: expanded ? `0 20px 60px ${primary}30` : `0 4px 12px ${primary}15`,
  minHeight: expanded ? '300px' : '180px'
  }}
  >
  <h3 style={{ margin: '0 0 12px 0', color: primary, fontSize: expanded ? '24px' : '20px', transition: 'font-size 400ms' }}>
  Expandable Card
  </h3>
  <p style={{ margin: 0, color: '#64748b', fontSize: '14px', lineHeight: 1.6 }}>
  Click to {expanded ? 'collapse' : 'expand'} this card
  {expanded && '. This is additional content that appears when the card is expanded.'}
  </p>
  </div>
  );
};