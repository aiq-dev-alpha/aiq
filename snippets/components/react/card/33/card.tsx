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
        borderRadius: '8px',
        padding: '22px',
        boxShadow: '0 2px 4px rgba(0,0,0,0.06)',
        maxWidth: '400px',
        border: 'none',
        transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 10px 28px rgba(0,0,0,0.12)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 4px 10px rgba(0,0,0,0.08)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 12px', color: primary, fontSize: '14px', fontWeight: '500' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '14px', lineHeight: '1.6' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '16px', paddingTop: '12px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '14px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};