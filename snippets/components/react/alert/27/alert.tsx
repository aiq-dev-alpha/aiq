import React from 'react';

export interface ComponentProps {
  message?: string;
  type?: 'info' | 'success' | 'warning' | 'error';
  theme?: { primary?: string; background?: string };
  className?: string;
  dismissible?: boolean;
  onDismiss?: () => void;
}

export const Component: React.FC<ComponentProps> = ({
  message = 'This is an alert message',
  type = 'info',
  theme = {},
  className = '',
  dismissible = false,
  onDismiss
}) => {
  const colors = {
    info: { bg: '#ecfeff', color: '#06b6d4', border: '#06b6d4' },
    success: { bg: '#ecfdf5', color: '#2563eb', border: '#2563eb' },
    warning: { bg: '#fffbeb', color: '#f59e0b', border: '#f59e0b' },
    error: { bg: '#fef2f2', color: '#ef4444', border: '#ef4444' }
  };

  const currentColor = colors[type];
  const primary = theme.primary || currentColor.color;
  const background = theme.background || currentColor.bg;

  return (
    <div
      className={className}
      style={{
        padding: '22px 30px',
        backgroundColor: background,
        border: `2px solid ${primary}`,
        borderRadius: '22px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: '20px',
        maxWidth: '600px',
        boxShadow: '0 16px 30px rgba(0,0,0,0.22)'
      }}
    >
      <div style={{ color: primary, fontWeight: '900', flex: 1 }}>
        {message}
      </div>
      {dismissible && (
        <button
          onClick={onDismiss}
          style={{
            background: 'none',
            border: 'none',
            color: primary,
            cursor: 'pointer',
            fontSize: '18px',
            padding: '0',
            lineHeight: '1.6'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};