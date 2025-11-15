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
  const primary = theme.primary || '#ef4444';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.45)',
          zIndex: 999,
          backdropFilter: 'blur(8px)'
        }}
        onClick={onClose}
      />
      <div
        className={className}
        style={{
          position: 'fixed',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%) scale(1)',
          backgroundColor: '#fff',
          borderRadius: '24px',
          padding: '36px',
          boxShadow: '0 12px 28px rgba(0,0,0,0.25)',
          maxWidth: '600px',
          width: '90%',
          zIndex: 1000,
          animation: 'modalFadeIn 0.3s ease-out'
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
          <h2 style={{ margin: 0, color: primary, fontSize: '13px', fontWeight: '400' }}>
            {title}
          </h2>
          <button
            onClick={onClose}
            style={{
              background: 'none',
              border: 'none',
              fontSize: '13px',
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