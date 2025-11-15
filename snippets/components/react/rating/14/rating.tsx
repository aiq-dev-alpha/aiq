import React from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const primary = theme.primary || '#22c55e';
  const bg = theme.background || '#ffffff';
  return (
    <div className={className} onClick={() => onInteract?.('click')} style={{ padding: '20px', backgroundColor: bg, border: `1px solid ${primary}20`, borderLeft: `4px solid ${primary}`, borderRadius: '12px', cursor: 'pointer', boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <div style={{ width: '12px', height: '12px', borderRadius: '50%', backgroundColor: primary }} />
        <span style={{ fontSize: '15px', fontWeight: 500 }}>Item {idx}</span>
      </div>
    </div>
  );
};
