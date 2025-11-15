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
    primary: { bg: '#8b5cf6', color: '#fff' },
    success: { bg: '#8b5cf6', color: '#fff' },
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
        gap: '15px',
        padding: '9px 13px',
        backgroundColor: primary,
        color: style.color,
        borderRadius: '16px',
        fontSize: '17px',
        fontWeight: '400',
        lineHeight: '1.6'
      }}
    >
      {dot && (
        <span style={{
          width: '7px',
          height: '7px',
          borderRadius: '50%',
          backgroundColor: 'currentColor'
        }} />
      )}
      {label}
    </span>
  );
};