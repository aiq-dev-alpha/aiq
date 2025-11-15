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
    info: { bg: '#faf5ff', color: '#8b5cf6', border: '#8b5cf6' },
    success: { bg: '#ecfdf5', color: '#5b21b6', border: '#5b21b6' },
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
        padding: '20px 27px',
        backgroundColor: background,
        border: `1px solid ${primary}`,
        borderRadius: '19px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        gap: '2px',
        maxWidth: '600px',
        boxShadow: '0 3px 11px rgba(0,0,0,0.08)'
      }}
    >
      <div style={{ color: primary, fontWeight: '800', flex: 1 }}>
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
            lineHeight: '1.7'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};