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
        borderRadius: '16px',
        padding: '31px',
        boxShadow: '0 2px 5px rgba(0,0,0,0.06)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.2s ease'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 15px 38px rgba(0,0,0,0.14)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 6px 15px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 13px', color: primary, fontSize: '14px', fontWeight: '400' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '14px', lineHeight: '1.5' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '17px', paddingTop: '13px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '14px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};