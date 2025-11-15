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
        borderRadius: '29px',
        padding: '27px',
        boxShadow: '0 19px 32px rgba(0,0,0,0.28)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 15px 33px rgba(0,0,0,0.12)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 9px 15px rgba(0,0,0,0.08)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 17px', color: primary, fontSize: '19px', fontWeight: '800' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '19px', lineHeight: '1.8' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '21px', paddingTop: '17px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '19px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};