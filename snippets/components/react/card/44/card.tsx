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
  const primary = theme.primary || '#b45309';
  const background = theme.background || '#fff';
  
  return (
    <div
      className={className}
      style={{
        backgroundColor: background,
        borderRadius: '13px',
        padding: '26px',
        boxShadow: '0 8px 18px rgba(0,0,0,0.18)',
        maxWidth: '400px',
        border: '1px solid #e5e7eb',
        transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 14px 32px rgba(0,0,0,0.12)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 6px 14px rgba(0,0,0,0.08)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 14px', color: primary, fontSize: '20px', fontWeight: '500' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '20px', lineHeight: '1.4' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '18px', paddingTop: '14px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '20px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};