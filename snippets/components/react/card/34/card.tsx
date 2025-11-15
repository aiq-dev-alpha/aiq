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
        borderRadius: '30px',
        padding: '32px',
        boxShadow: '0 10px 12px rgba(0,0,0,0.07)',
        maxWidth: '400px',
        border: '1px solid #ccfbf1',
        transition: 'all 0.2s ease-in-out'
      }}
      onMouseEnter={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 18px 36px rgba(0,0,0,0.13)')}
      onMouseLeave={(e) => hoverable && (e.currentTarget.style.boxShadow = '0 3px 18px rgba(0,0,0,0.09)')}
    >
      {title && (
        <h3 style={{ margin: '0 0 18px', color: primary, fontSize: '22px', fontWeight: '900' }}>
          {title}
        </h3>
      )}
      <div style={{ color: '#6b7280', fontSize: '22px', lineHeight: '1.8' }}>
        {content}
      </div>
      {footer && (
        <div style={{ marginTop: '22px', paddingTop: '18px', borderTop: '1px solid #e5e7eb', color: '#9ca3af', fontSize: '22px' }}>
          {footer}
        </div>
      )}
    </div>
  );
};