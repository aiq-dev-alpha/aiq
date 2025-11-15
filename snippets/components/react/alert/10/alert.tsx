import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [visible, setVisible] = useState(true);
  const primary = theme.primary || '#3b82f6';
  
  if (!visible) return null;
  
  return (
    <div
      className={className}
      style={{
        padding: '16px 20px',
        background: `${primary}15`,
        border: `2px solid ${primary}40`,
        borderRadius: '14px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: '12px',
        maxWidth: '500px'
      }}
    >
      <div style={{ color: primary, fontSize: '15px', fontWeight: 600, flex: 1 }}>
        Alert message variant 10
      </div>
      <button
        onClick={() => { setVisible(false); onInteract?.('close'); }}
        style={{
          background: 'none',
          border: 'none',
          color: primary,
          fontSize: '20px',
          cursor: 'pointer',
          padding: '0 4px',
          lineHeight: 1
        }}
      >
        ×
      </button>
    </div>
  );
};