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
    info: '#ec4899',
    success: '#10b981',
    warning: '#f59e0b',
    error: '#ef4444'
  };
  
  const backgrounds = {
    info: '#fdf2f8',
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
        gap: '4px',
        padding: '22px 26px',
        backgroundColor: bg,
        borderLeft: `3px solid ${primary}`,
        borderRadius: '18px',
        boxShadow: '0 8px 20px rgba(0,0,0,0.2)',
        maxWidth: '410px',
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
            lineHeight: '1',
            flexShrink: 0
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};