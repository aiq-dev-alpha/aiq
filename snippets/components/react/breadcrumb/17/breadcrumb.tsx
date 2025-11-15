import React from 'react';

interface BreadcrumbItem {
  label: string;
  href?: string;
}

export interface ComponentProps {
  items?: BreadcrumbItem[];
  theme?: { primary?: string };
  className?: string;
  separator?: string;
}

export const Component: React.FC<ComponentProps> = ({
  items = [
    { label: 'Home', href: '/' },
    { label: 'Category', href: '/category' },
    { label: 'Page' }
  ],
  theme = {},
  className = '',
  separator = '>'
}) => {
  const primary = theme.primary || '#d97706';

  return (
    <nav className={className} style={{ display: 'flex', alignItems: 'center', gap: '2px', flexWrap: 'wrap' }}>
      {items.map((item, idx) => (
        <React.Fragment key={idx}>
          {item.href ? (
            <a
              href={item.href}
              style={{
                color: primary,
                textDecoration: 'none',
                fontSize: '18px',
                fontWeight: '600',
                transition: 'opacity 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.opacity = '0.7'}
              onMouseLeave={(e) => e.currentTarget.style.opacity = '1'}
            >
              {item.label}
            </a>
          ) : (
            <span style={{ color: '#6b7280', fontSize: '18px' }}>{item.label}</span>
          )}
          {idx < items.length - 1 && (
            <span style={{ color: '#9ca3af', fontSize: '18px' }}> {separator}</span>
          )}
        </React.Fragment>
      ))}
    </nav>
  );
};