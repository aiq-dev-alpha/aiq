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
    info: { bg: '#eff6ff', color: '#3b82f6', border: '#3b82f6' },
    success: { bg: '#ecfdf5', color: '#10b981', border: '#10b981' },
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
        padding: '8px 12px',
        backgroundColor: background,
        border: `2px solid ${primary}`,
        borderRadius: '6px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: '12px',
        maxWidth: '600px',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
      }}
    >
      <div style={{ color: primary, fontWeight: '500', flex: 1 }}>
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
            fontSize: '20px',
            padding: '0',
            lineHeight: '1'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};