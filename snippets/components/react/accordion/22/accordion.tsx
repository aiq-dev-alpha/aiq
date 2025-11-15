import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [hover, setHover] = useState(false);
  const primary = theme.primary || '#84cc16';
  return (
    <div className={className} onMouseEnter={() => setHover(true)} onMouseLeave={() => setHover(false)} onClick={() => onInteract?.('click')} style={{ padding: '14px 28px', backgroundColor: 'transparent', color: primary, border: `2px solid ${primary}`, borderRadius: '8px', cursor: 'pointer', fontSize: '14px', fontWeight: 500, transform: hover ? 'translateY(-2px)' : 'translateY(0)', boxShadow: hover ? `0 8px 16px ${primary}30` : 'none', transition: 'all 250ms cubic-bezier(0.4, 0, 0.2, 1)' }}>
      Hover Effect
    </div>
  );
};
