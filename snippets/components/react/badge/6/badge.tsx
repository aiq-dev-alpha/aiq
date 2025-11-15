import React from 'react';

export interface ComponentProps {
  label?: string;
  variant?: 'primary' | 'success' | 'warning' | 'error';
  theme?: { primary?: string };
  className?: string;
  dot?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Badge',
  variant = 'primary',
  theme = {},
  className = '',
  dot = false
}) => {
  const variants = {
    primary: { bg: '#f59e0b', color: '#fff' },
    success: { bg: '#10b981', color: '#fff' },
    warning: { bg: '#f59e0b', color: '#fff' },
    error: { bg: '#ef4444', color: '#fff' }
  };

  const style = variants[variant];
  const primary = theme.primary || style.bg;

  return (
    <span
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '16px',
        padding: '18px 32px',
        backgroundColor: primary,
        color: style.color,
        borderRadius: '14px',
        fontSize: '12px',
        fontWeight: '500',
        lineHeight: '1'
      }}
    >
      {dot && (
        <span style={{
          width: '6px',
          height: '6px',
          borderRadius: '50%',
          backgroundColor: 'currentColor'
        }} />
      )}
      {label}
    </span>
  );
};