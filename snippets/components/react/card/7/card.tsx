import React from 'react';

type Elevation = 'none' | 'sm' | 'md' | 'lg' | 'xl';
type Radius = 'none' | 'sm' | 'md' | 'lg' | 'full';

interface Props {
  children: React.ReactNode;
  elevation?: Elevation;
  radius?: Radius;
  bordered?: boolean;
  hoverable?: boolean;
  title?: React.ReactNode;
  actions?: React.ReactNode;
  style?: React.CSSProperties;
}

export const Card: React.FC<Props> = ({
  children,
  elevation = 'md',
  radius = 'md',
  bordered = false,
  hoverable = false,
  title,
  actions,
  style = {}
}) => {
  const elevations: Record<Elevation, string> = {
    none: 'none',
    sm: '0 1px 2px rgba(0,0,0,0.05)',
    md: '0 4px 6px rgba(0,0,0,0.07)',
    lg: '0 10px 15px rgba(0,0,0,0.1)',
    xl: '0 20px 25px rgba(0,0,0,0.15)'
  };

  const radii: Record<Radius, string> = {
    none: '0',
    sm: '0.375rem',
    md: '0.75rem',
    lg: '1rem',
    full: '9999px'
  };

  return (
    <div
      style={{
        backgroundColor: '#fff',
        borderRadius: radii[radius],
        boxShadow: elevations[elevation],
        border: bordered ? '1px solid #e5e7eb' : 'none',
        overflow: 'hidden',
        cursor: hoverable ? 'pointer' : 'default',
        transition: hoverable ? 'all 0.2s' : 'none',
        fontFamily: 'system-ui, sans-serif',
        ...style
      }}
    >
      {title && (
        <div style={{ padding: '1.25rem', borderBottom: '1px solid #e5e7eb', fontWeight: 600, fontSize: '1.125rem' }}>
          {title}
        </div>
      )}
      <div style={{ padding: '1.25rem' }}>{children}</div>
      {actions && (
        <div style={{ padding: '1rem 1.25rem', borderTop: '1px solid #e5e7eb', display: 'flex', gap: '0.75rem', justifyContent: 'flex-end' }}>
          {actions}
        </div>
      )}
    </div>
  );
};
