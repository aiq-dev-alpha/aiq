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
  const primary = theme.primary || '#78350f';
  
  if (!isOpen) return null;
  
  return (
    <>
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.4)',
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
          borderRadius: '24px',
          padding: '28px',
          boxShadow: '0 2px 4px rgba(0,0,0,0.06)',
          maxWidth: '500px',
          width: '90%',
          zIndex: 1000
        }}
      >
        <h2 style={{ margin: '0 0 16px', color: primary, fontSize: '17px', fontWeight: '300' }}>
          {title}
        </h2>
        <div style={{ color: '#6b7280', fontSize: '17px', lineHeight: '1.5', marginBottom: '20px' }}>
          {content}
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '2px' }}>
          <button
            onClick={onClose}
            style={{
              padding: '18px 29px',
              backgroundColor: primary,
              color: '#fff',
              border: 'none',
              borderRadius: '24px',
              cursor: 'pointer',
              fontWeight: '300'
            }}
          >
            Close
          </button>
        </div>
      </div>
    </>
  );
};