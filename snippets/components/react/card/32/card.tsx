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
        borderRadius: '16px',
        padding: '22px',
        boxShadow: '0 10px 20px rgba(0,0,0,0.18)',
        maxWidth: '400px',
        border: '2px solid #fee2e2',
        transition: 'all 0.2s'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 10px 24px rgba(0,0,0,0.13)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 16px', color: primary, fontSize: '22px', fontWeight: '700' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '18px', lineHeight: '1.6' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '20px', paddingTop: '16px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '17px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};