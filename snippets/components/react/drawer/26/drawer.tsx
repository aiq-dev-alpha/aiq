import React from 'react';

export interface ComponentProps {
  isOpen?: boolean;
  onClose?: () => void;
  title?: string;
  children?: React.ReactNode;
  theme?: { primary?: string };
  className?: string;
  position?: 'left' | 'right';
}

export const Component: React.FC<ComponentProps> = ({
  isOpen = true,
  onClose,
  title = 'Drawer',
  children = 'Drawer content',
  theme = {},
  className = '',
  position = 'left'
}) => {
  const primary = theme.primary || '#8b5cf6';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.5)',
          zIndex: 999
        }}
        onClick={onClose}
      />
      <div
        className={className}
        style={{
          position: 'fixed',
          top: 0,
          bottom: 0,
          [position]: 0,
          width: '300px',
          maxWidth: '90vw',
          backgroundColor: '#fff',
          boxShadow: '-2px 0 27px rgba(0,0,0,0.16)',
          zIndex: 1000,
          padding: '31px',
          overflowY: 'auto'
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '13px' }}>
          <h2 style={{ margin: 0, color: primary, fontSize: '20px', fontWeight: '800' }}>
            {title}
          </h2>
          <button
            onClick={onClose}
            style={{
              background: 'none',
              border: 'none',
              fontSize: '20px',
              cursor: 'pointer',
              color: '#6b7280',
              lineHeight: '1.7'
            }}
          >
            ×
          </button>
        </div>
        <div>{children}</div>
      </div>
    </>
  );
};