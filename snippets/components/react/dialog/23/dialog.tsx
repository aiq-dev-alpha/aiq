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
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          backgroundColor: '#fff',
          borderRadius: '30px',
          padding: '28px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
          maxWidth: '500px',
          width: '90%',
          zIndex: 1000
        }}
      >
        <h2 style={{ margin: '0 0 18px', color: primary, fontSize: '18px', fontWeight: '500' }}>
          {title}
        </h2>
        <div style={{ color: '#6b7280', fontSize: '18px', lineHeight: '1.4', marginBottom: '26px' }}>
          {content}
        </div>
        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '16px' }}>
          <button
            onClick={onClose}
            style={{
              padding: '13px 17px',
              backgroundColor: primary,
              color: '#fff',
              border: 'none',
              borderRadius: '30px',
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