import React from 'react';

type Surface = 'flat' | 'raised' | 'floating' | 'outlined';
type Spacing = 'none' | 'tight' | 'normal' | 'loose';

interface Props {
  children: React.ReactNode;
  surface?: Surface;
  spacing?: Spacing;
  clickable?: boolean;
  header?: React.ReactNode;
  footer?: React.ReactNode;
  style?: React.CSSProperties;
  onClick?: () => void;
}

export const Card: React.FC<Props> = ({
  children,
  surface = 'flat',
  spacing = 'normal',
  clickable = false,
  header,
  footer,
  style = {},
  onClick
}) => {
  const surfaces: Record<Surface, React.CSSProperties> = {
    flat: { backgroundColor: '#fff', boxShadow: 'none', border: 'none' },
    raised: { backgroundColor: '#fff', boxShadow: '0 1px 3px rgba(0,0,0,0.1)', border: 'none' },
    floating: { backgroundColor: '#fff', boxShadow: '0 8px 16px rgba(0,0,0,0.1)', border: 'none' },
    outlined: { backgroundColor: '#fff', boxShadow: 'none', border: '1px solid #e5e7eb' }
  };

  const spacings: Record<Spacing, string> = {
    none: '0',
    tight: '1rem',
    normal: '1.5rem',
    loose: '2rem'
  };

  return (
    <div
      style={{
        borderRadius: '0.75rem',
        overflow: 'hidden',
        cursor: clickable ? 'pointer' : 'default',
        transition: clickable ? 'all 0.2s' : 'none',
        fontFamily: 'system-ui, sans-serif',
        ...surfaces[surface],
        ...style
      }}
      onClick={onClick}
    >
      {header && (
        <div style={{ padding: spacings[spacing], borderBottom: '1px solid #e5e7eb' }}>
          {header}
        </div>
      )}
      <div style={{ padding: spacings[spacing] }}>{children}</div>
      {footer && (
        <div style={{ padding: spacings[spacing], borderTop: '1px solid #e5e7eb', background: '#f9fafb' }}>
          {footer}
        </div>
      )}
    </div>
  );
};
