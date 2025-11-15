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
  position = 'right'
}) => {
  const primary = theme.primary || '#14b8a6';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.55)',
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
          width: '340px',
          maxWidth: '90vw',
          backgroundColor: '#fff',
          boxShadow: '2px 0 26px rgba(0,0,0,0.19)',
          zIndex: 1000,
          padding: '30px',
          overflowY: 'auto'
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
          <h2 style={{ margin: 0, color: primary, fontSize: '17px', fontWeight: '300' }}>
            {title}
          </h2>
          <button
            onClick={onClose}
            style={{
              background: 'none',
              border: 'none',
              fontSize: '17px',
              cursor: 'pointer',
              color: '#6b7280',
              lineHeight: '1.5'
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