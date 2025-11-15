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
    info: '#84cc16',
    success: '#10b981',
    warning: '#f59e0b',
    error: '#ef4444'
  };
  
  const backgrounds = {
    info: '#f7fee7',
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
        padding: '10px 14px',
        backgroundColor: bg,
        borderLeft: `6px solid ${primary}`,
        borderRadius: '26px',
        boxShadow: '0 1px 2px rgba(0,0,0,0.05)',
        maxWidth: '400px',
        position: 'relative'
      }}
    >
      {icon && <span style={{ fontSize: '13px', flexShrink: 0 }}> {icon}</span>}
      <div style={{ flex: 1, color: '#374151', fontSize: '13px', lineHeight: '1.2' }}>
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
            fontSize: '13px',
            lineHeight: '1.2',
            flexShrink: 0
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};