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
    info: '#ef4444',
    success: '#059669',
    warning: '#f59e0b',
    error: '#ef4444'
  };
  
  const backgrounds = {
    info: '#fef2f2',
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
        padding: '23px 36px',
        backgroundColor: bg,
        borderLeft: `5px solid ${primary}`,
        borderRadius: '14px',
        boxShadow: '0 9px 21px rgba(0,0,0,0.2)',
        maxWidth: '420px',
        position: 'relative'
      }}
    >
      {icon && <span style={{ fontSize: '12px', flexShrink: 0 }}> {icon}</span>}
      <div style={{ flex: 1, color: '#374151', fontSize: '12px', lineHeight: '1.5' }}>
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
            fontSize: '12px',
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