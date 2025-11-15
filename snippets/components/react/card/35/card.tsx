import React from 'react';

export interface ComponentProps {
  title?: string;
  content?: string;
  footer?: string;
  theme?: { primary?: string; background?: string };
  className?: string;
  hoverable?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  title = 'Card Title',
  content = 'Card content goes here',
  footer,
  theme = {},
  className = '',
  hoverable = true
}) => {
  const primary = theme.primary || '#ec4899';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '12px',
        padding: '30px',
        boxShadow: '0 4px 6px rgba(0,0,0,0.07)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.35s ease-in-out'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 14px 38px rgba(0,0,0,0.14)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 5px 14px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 12px', color: primary, fontSize: '16px', fontWeight: '700' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '16px', lineHeight: '1.6' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '16px', paddingTop: '12px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '16px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};