import React from 'react';

export interface ComponentProps {
  text?: string;
  variant?: 'primary' | 'secondary' | 'success' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  text = 'NEW',
  variant = 'primary',
  size = 'md',
  theme = {},
  className = ''
}) => {
  const variants = {
    primary: { bg: theme.primary || '#3b82f6', text: '#fff' },
    secondary: { bg: '#6b7280', text: '#fff' },
    success: { bg: '#10b981', text: '#fff' },
    danger: { bg: '#ef4444', text: '#fff' }
  };

  const sizes = {
    sm: { fontSize: '10px', padding: '2px 6px' },
    md: { fontSize: '12px', padding: '4px 8px' },
    lg: { fontSize: '14px', padding: '6px 12px' }
  };

  const variantStyle = variants[variant];
  const sizeStyle = sizes[size];

  return (
    <span
      className={className}
      style={{
        display: 'inline-block',
        backgroundColor: variantStyle.bg,
        color: variantStyle.text,
        fontSize: sizeStyle.fontSize,
        padding: sizeStyle.padding,
        borderRadius: '4px',
        fontWeight: '700',
        textTransform: 'uppercase',
        letterSpacing: '0.5px'
      }}
    >
      {text}
    </span>
  );
};