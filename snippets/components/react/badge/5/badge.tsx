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
    primary: { bg: '#ec4899', color: '#fff' },
    success: { bg: '#ec4899', color: '#fff' },
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
        gap: '19px',
        padding: '22px 29px',
        backgroundColor: primary,
        color: style.color,
        borderRadius: '35px',
        fontSize: '19px',
        fontWeight: '800',
        lineHeight: '1.4'
      }}
    >
      {dot && (
        <span style={{
          width: '11px',
          height: '11px',
          borderRadius: '50%',
          backgroundColor: 'currentColor'
        }} />
      )}
      {label}
    </span>
  );
};