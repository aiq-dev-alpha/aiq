import React, { useState } from 'react';

export interface ComponentProps {
  type?: 'info' | 'success' | 'warning' | 'error';
  title?: string;
  message?: string;
  dismissible?: boolean;
  onDismiss?: () => void;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  type = 'info',
  title = 'Alert',
  message = 'This is an alert message',
  dismissible = false,
  onDismiss,
  theme = {},
  className = ''
}) => {
  const [isVisible, setIsVisible] = useState(true);

  const typeConfig = {
    info: { bg: '#dbeafe', border: '#3b82f6', text: '#1e40af', icon: 'ℹ' },
    success: { bg: '#d1fae5', border: '#10b981', text: '#065f46', icon: '✓' },
    warning: { bg: '#fef3c7', border: '#f59e0b', text: '#92400e', icon: '⚠' },
    error: { bg: '#fee2e2', border: '#ef4444', text: '#991b1b', icon: '✕' }
  };

  const config = typeConfig[type];

  const handleDismiss = () => {
    setIsVisible(false);
    setTimeout(() => onDismiss?.(), 300);
  };

  if (!isVisible) return null;

  return (
    <div
      className={className}
      style={{
        backgroundColor: config.bg,
        borderLeft: `4px solid ${config.border}`,
        color: config.text,
        padding: '16px',
        borderRadius: '0 8px 8px 0',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
        display: 'flex',
        alignItems: 'flex-start',
        gap: '12px',
        transition: 'all 0.3s ease'
      }}
    >
      <span style={{ fontSize: '20px', fontWeight: '700' }}>{config.icon}</span>
      <div style={{ flex: 1 }}>
        {title && <h3 style={{ fontWeight: '700', marginBottom: '4px', fontSize: '15px' }}>{title}</h3>}
        <p style={{ fontSize: '14px', margin: 0 }}>{message}</p>
      </div>
      {dismissible && (
        <button
          onClick={handleDismiss}
          style={{
            background: 'none',
            border: 'none',
            color: config.text,
            cursor: 'pointer',
            fontSize: '20px',
            padding: '0',
            opacity: 0.7
          }}
          onMouseEnter={(e) => e.currentTarget.style.opacity = '1'}
          onMouseLeave={(e) => e.currentTarget.style.opacity = '0.7'}
        >
          ×
        </button>
      )}
    </div>
  );
};