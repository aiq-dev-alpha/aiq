import React from 'react';

export interface ComponentProps {
  status?: 'success' | 'warning' | 'error' | 'info';
  label?: string;
  icon?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  status = 'info',
  label = 'Status',
  icon = true,
  theme = {},
  className = ''
}) => {
  const colors = {
    success: { bg: '#d1fae5', text: '#065f46', icon: '#10b981' },
    warning: { bg: '#fef3c7', text: '#92400e', icon: '#f59e0b' },
    error: { bg: '#fee2e2', text: '#991b1b', icon: '#ef4444' },
    info: { bg: '#dbeafe', text: '#1e40af', icon: '#3b82f6' }
  };

  const config = colors[status];

  return (
    <div
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '6px',
        padding: '6px 14px',
        backgroundColor: config.bg,
        borderRadius: '6px',
        fontSize: '13px',
        color: config.text,
        fontWeight: '600'
      }}
    >
      {icon && (
        <div
          style={{
            width: '8px',
            height: '8px',
            borderRadius: '50%',
            backgroundColor: config.icon
          }}
        />
      )}
      <span>{label}</span>
    </div>
  );
};