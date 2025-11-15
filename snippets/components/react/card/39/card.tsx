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
  const primary = theme.primary || '#ef4444';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '26px',
        padding: '18px',
        boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
        maxWidth: '400px',
        border: '2px solid #fee2e2',
        transition: 'all 0.35s ease'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 6px 20px rgba(0,0,0,0.13)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 2px 6px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 12px', color: primary, fontSize: '17px', fontWeight: '300' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '17px', lineHeight: '1.2' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '16px', paddingTop: '12px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '17px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};