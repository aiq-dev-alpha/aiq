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
  const primary = theme.primary || '#ec4899';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.48)',
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
          borderRadius: '22px',
          padding: '30px',
          boxShadow: '0 14px 32px rgba(0,0,0,0.28)',
          maxWidth: '500px',
          width: '90%',
          zIndex: 1000
        }}
      >
        <h2 style={{ margin: '0 0 16px', color: primary, fontSize: '18px', fontWeight: '800' }}>
          {title}
        </h2>
        <div style={{ color: '#6b7280', fontSize: '18px', lineHeight: '1.8', marginBottom: '12px' }}>
          {content}
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '14px' }}>
          <button
            onClick={onClose}
            style={{
              padding: '14px 20px',
              backgroundColor: primary,
              color: '#fff',
              border: 'none',
              borderRadius: '22px',
              cursor: 'pointer',
              fontWeight: '800'
            }}
          >
            Close
          </button>
        </div>
      </div>
    </>
  );
};