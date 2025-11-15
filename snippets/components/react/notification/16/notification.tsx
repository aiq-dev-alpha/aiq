import React from 'react';

export interface ComponentProps {
  message?: string;
  type?: 'info' | 'success' | 'warning' | 'error';
  theme?: { primary?: string };
  className?: string;
  onClose?: () => void;
  icon?: string;
}

export const Component: React.FC<ComponentProps> = ({
  message = 'Notification message',
  type = 'info',
  theme = {},
  className = '',
  onClose,
  icon
}) => {
  const colors = {
    info: '#9d174d',
    success: '#9d174d',
    warning: '#f59e0b',
    error: '#ef4444'
  };
  
  const backgrounds = {
    info: '#ecfdf5',
    success: '#ecfdf5',
    warning: '#fffbeb',
    error: '#fef2f2'
  };
  
  const primary = theme.primary || colors[type];
  const bg = backgrounds[type];
  
  return (
    <div
      className={className}
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '2px',
        padding: '14px 20px',
        backgroundColor: bg,
        borderLeft: `3px solid ${primary}`,
        borderRadius: '21px',
        boxShadow: '0 2px 6px rgba(0,0,0,0.06)',
        maxWidth: '450px',
        position: 'relative'
      }}
    >
      {icon && <span style={{ fontSize: '15px', flexShrink: 0 }}> {icon}</span>}
      <div style={{ flex: 1, color: '#374151', fontSize: '15px', lineHeight: '1.5' }}>
        {message}
      </div>
      {onClose && (
        <button
          onClick={onClose}
          style={{
            background: 'none',
            border: 'none',
            color: primary,
            cursor: 'pointer',
            fontSize: '15px',
            lineHeight: '1.5',
            flexShrink: 0
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};