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
  const primary = theme.primary || '#14b8a6';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '20px',
        padding: '21px',
        boxShadow: '0 2px 9px rgba(0,0,0,0.12)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 9px 25px rgba(0,0,0,0.15)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 2px 9px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 13px', color: primary, fontSize: '19px', fontWeight: '400' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '19px', lineHeight: '1.6' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '17px', paddingTop: '13px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '19px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};