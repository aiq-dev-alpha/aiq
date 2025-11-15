import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const primary = theme.primary || '#14b8a6';
  const background = theme.background || '#ffffff';
  
  return (
    <div
      className={className}
      onClick={() => { setActive(!active); onInteract?.('hover_lift'); }}
      style={{
        width: '320px',
        padding: '24px',
        background: background,
        backdropFilter: 'none',
        border: active ? `3px solid ${primary}` : `2px solid ${primary}40`,
        borderRadius: '16px',
        cursor: 'pointer',
        transition: 'all 350ms cubic-bezier(0.34, 1.56, 0.64, 1)',
        boxShadow: active ? `0 20px 40px ${primary}40` : `0 8px 24px ${primary}20`,
        transform: active ? 'translateY(-8px)' : 'translateY(0)'
      }}
    >
      <h3 style={{ margin: '0 0 12px 0', color: primary, fontSize: '20px', fontWeight: 700 }}>
        Hover Lift Card
      </h3>
      <p style={{ margin: 0, color: '#64748b', fontSize: '14px', lineHeight: 1.6 }}>
        Click to {active ? 'deactivate' : 'activate'} this hover lift card variant.
      </p>
    </div>
  );
};