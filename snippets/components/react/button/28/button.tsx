import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [showMenu, setShowMenu] = useState(false);
  const primary = theme.primary || '#f59e0b';

  return (
    <div className={className} style={{ display: 'inline-flex', position: 'relative' }}>
      <button
        onClick={() => onInteract?.('main')}
        style={{
          padding: '12px 20px',
          backgroundColor: primary,
          color: '#ffffff',
          border: 'none',
          borderTopLeftRadius: '16px',
          borderBottomLeftRadius: '16px',
          fontSize: '14px',
          fontWeight: 500,
          cursor: 'pointer'
        }}
      >
        Action
      </button>
      <button
        onClick={() => setShowMenu(!showMenu)}
        style={{
          padding: '12px',
          backgroundColor: primary,
          color: '#ffffff',
          border: 'none',
          borderLeft: '1px solid rgba(255,255,255,0.3)',
          borderTopRightRadius: '16px',
          borderBottomRightRadius: '16px',
          fontSize: '12px',
          cursor: 'pointer'
        }}
      >
        ▼
      </button>
      {showMenu && (
        <div style={{
          position: 'absolute',
          top: '100%',
          right: 0,
          marginTop: '4px',
          backgroundColor: '#ffffff',
          border: '1px solid #e5e7eb',
          borderRadius: '16px',
          boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
          padding: '8px 0',
          minWidth: '120px',
          zIndex: 10
        }}>
          <div style={{ padding: '8px 16px', cursor: 'pointer' }}>Option 1</div>
          <div style={{ padding: '8px 16px', cursor: 'pointer' }}>Option 2</div>
        </div>
      )}
    </div>
  );
};
