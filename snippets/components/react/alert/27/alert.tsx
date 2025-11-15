import React from 'react';

interface AlertProps {
  title: string;
  message?: string;
  variant?: 'filled' | 'outlined' | 'standard';
  severity?: 'success' | 'error' | 'warning' | 'info';
  action?: React.ReactNode;
  icon?: React.ReactNode;
}

export const Alert: React.FC<AlertProps> = ({
  title,
  message,
  variant = 'filled',
  severity = 'info',
  action,
  icon
}) => {
  const severityConfig = {
    success: { color: '#10b981', bg: '#d1fae5', border: '#10b981', emoji: '✅' },
    error: { color: '#ef4444', bg: '#fee2e2', border: '#ef4444', emoji: '❌' },
    warning: { color: '#f59e0b', bg: '#fef3c7', border: '#f59e0b', emoji: '⚠️' },
    info: { color: '#3b82f6', bg: '#dbeafe', border: '#3b82f6', emoji: 'ℹ️' }
  };

  const config = severityConfig[severity];

  const styles = {
    filled: {
      background: config.color,
      color: '#fff',
      border: 'none'
    },
    outlined: {
      background: '#fff',
      color: config.color,
      border: `2px solid ${config.border}`
    },
    standard: {
      background: config.bg,
      color: config.color,
      border: `1px solid ${config.border}`
    }
  };

  return (
    <div
      style={{
        ...styles[variant],
        padding: '16px 20px',
        borderRadius: '8px',
        display: 'flex',
        alignItems: 'flex-start',
        gap: '12px',
        width: '100%',
        boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
      }}
    >
      <span style={{ fontSize: '20px', marginTop: '2px' }}>
        {icon || config.emoji}
      </span>
      <div style={{ flex: 1 }}>
        <div style={{ fontWeight: 600, fontSize: '16px', marginBottom: message ? '4px' : 0 }}>
          {title}
        </div>
        {message && (
          <div style={{ fontSize: '14px', opacity: 0.9 }}>
            {message}
          </div>
        )}
      </div>
      {action && <div>{action}</div>}
    </div>
  );
};
