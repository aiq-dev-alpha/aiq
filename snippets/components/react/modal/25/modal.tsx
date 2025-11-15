import React from 'react';

export interface ComponentProps {
  isOpen?: boolean;
  onClose?: () => void;
  title?: string;
  children?: React.ReactNode;
  theme?: { primary?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  isOpen = true,
  onClose,
  title = 'Modal',
  children = 'Modal content',
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#ec4899';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.48)',
          zIndex: 999,
          backdropFilter: 'blur(10px)'
        }}
        onClick={onClose}
      />
      <div
        className={className}
        style={{
          position: 'fixed',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%) scale(1.00)',
          backgroundColor: '#fff',
          borderRadius: '32px',
          padding: '34px',
          boxShadow: '0 18px 32px rgba(0,0,0,0.28)',
          maxWidth: '600px',
          width: '90%',
          zIndex: 1000,
          animation: 'modalFadeIn 0.3s ease-out'
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
          <h2 style={{ margin: 0, color: primary, fontSize: '18px', fontWeight: '700' }}>
            {title}
          </h2>
          <button
            onClick={onClose}
            style={{
              background: 'none',
              border: 'none',
              fontSize: '18px',
              cursor: 'pointer',
              color: '#6b7280',
              lineHeight: '1.8'
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