import React from 'react';

export interface ComponentProps {
  isOpen?: boolean;
  onClose?: () => void;
  title?: string;
  content?: string;
  theme?: { primary?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  isOpen = true,
  onClose,
  title = 'Dialog Title',
  content = 'Dialog content',
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#3b82f6';
  
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
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          backgroundColor: '#fff',
          borderRadius: '6px',
          padding: '24px',
          boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
          maxWidth: '500px',
          width: '90%',
          zIndex: 1000
        }}
      >
        <h2 style={{ margin: '0 0 16px', color: primary, fontSize: '20px', fontWeight: '600' }}>
          {title}
        </h2>
        <div style={{ color: '#6b7280', fontSize: '14px', lineHeight: '1.6', marginBottom: '20px' }}>
          {content}
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '8px' }}>
          <button
            onClick={onClose}
            style={{
              padding: '8px 12px',
              backgroundColor: primary,
              color: '#fff',
              border: 'none',
              borderRadius: '6px',
              cursor: 'pointer',
              fontWeight: '500'
            }}
          >
            Close
          </button>
        </div>
      </div>
    </>
  );
};