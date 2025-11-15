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
        borderRadius: '9px',
        padding: '31px',
        boxShadow: '0 7px 15px rgba(0,0,0,0.15)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.2s'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 19px 40px rgba(0,0,0,0.14)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 9px 19px rgba(0,0,0,0.09)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 15px', color: primary, fontSize: '21px', fontWeight: '600' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '17px', lineHeight: '1.6' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '19px', paddingTop: '15px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '16px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};