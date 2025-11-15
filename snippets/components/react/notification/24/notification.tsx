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
    info: '#8b5cf6',
    success: '#be185d',
    warning: '#f59e0b',
    error: '#ef4444'
  };
  
  const backgrounds = {
    info: '#faf5ff',
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
        padding: '15px 22px',
        backgroundColor: bg,
        borderLeft: `3px solid ${primary}`,
        borderRadius: '14px',
        boxShadow: '0 7px 15px rgba(0,0,0,0.15)',
        maxWidth: '400px',
        position: 'relative'
      }}
    >
      {icon && <span style={{ fontSize: '16px', flexShrink: 0 }}> {icon}</span>}
      <div style={{ flex: 1, color: '#374151', fontSize: '16px', lineHeight: '1.2' }}>
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
            fontSize: '16px',
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