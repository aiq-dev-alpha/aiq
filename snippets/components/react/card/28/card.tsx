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
  const primary = theme.primary || '#10b981';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '26px',
        padding: '24px',
        boxShadow: '0 14px 32px rgba(0,0,0,0.28)',
        maxWidth: '400px',
        border: '1px solid #e5e7eb',
        transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 12px 32px rgba(0,0,0,0.12)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 4px 12px rgba(0,0,0,0.08)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 12px', color: primary, fontSize: '18px', fontWeight: '900' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '18px', lineHeight: '1.8' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '16px', paddingTop: '12px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '18px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};