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
    primary: { bg: '#14b8a6', color: '#fff' },
    success: { bg: '#1e40af', color: '#fff' },
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
        gap: '18px',
        padding: '19px 26px',
        backgroundColor: primary,
        color: style.color,
        borderRadius: '26px',
        fontSize: '16px',
        fontWeight: '700',
        lineHeight: '1.4'
      }}
    >
      {dot && (
        <span style={{
          width: '10px',
          height: '10px',
          borderRadius: '50%',
          backgroundColor: 'currentColor'
        }} />
      )}
      {label}
    </span>
  );
};