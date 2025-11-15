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
  const primary = theme.primary || '#8b5cf6';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '15px',
        padding: '23px',
        boxShadow: '0 1px 2px rgba(0,0,0,0.05)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.3s ease'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 11px 27px rgba(0,0,0,0.15)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 2px 11px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 15px', color: primary, fontSize: '18px', fontWeight: '600' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '18px', lineHeight: '1.2' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '19px', paddingTop: '15px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '18px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};