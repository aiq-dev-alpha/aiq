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
  const primary = theme.primary || '#f59e0b';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '21px',
        padding: '28px',
        boxShadow: '0 3px 6px rgba(0,0,0,0.08)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.3s ease'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 16px 40px rgba(0,0,0,0.14)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 6px 16px rgba(0,0,0,0.09)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 12px', color: primary, fontSize: '15px', fontWeight: '400' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '15px', lineHeight: '1.7' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '16px', paddingTop: '12px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '15px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};