import React from 'react';

type Appearance = 'default' | 'subtle' | 'bordered' | 'shadowed';
type Padding = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

interface Props {
  children: React.ReactNode;
  appearance?: Appearance;
  padding?: Padding;
  interactive?: boolean;
  headerContent?: React.ReactNode;
  footerContent?: React.ReactNode;
  style?: React.CSSProperties;
  onSelect?: () => void;
}

export const Card: React.FC<Props> = ({
  children,
  appearance = 'default',
  padding = 'md',
  interactive = false,
  headerContent,
  footerContent,
  style = {},
  onSelect
}) => {
  const appearances: Record<Appearance, React.CSSProperties> = {
    default: { backgroundColor: '#fff', border: 'none', boxShadow: '0 1px 3px rgba(0,0,0,0.1)' },
    subtle: { backgroundColor: '#f9fafb', border: 'none', boxShadow: 'none' },
    bordered: { backgroundColor: '#fff', border: '2px solid #e5e7eb', boxShadow: 'none' },
    shadowed: { backgroundColor: '#fff', border: 'none', boxShadow: '0 10px 20px rgba(0,0,0,0.15)' }
  };

  const paddings: Record<Padding, string> = {
    xs: '0.5rem',
    sm: '1rem',
    md: '1.5rem',
    lg: '2rem',
    xl: '2.5rem'
  };

  return (
    <div
      style={{
        borderRadius: '0.875rem',
        overflow: 'hidden',
        cursor: interactive ? 'pointer' : 'default',
        transition: interactive ? 'transform 0.2s, box-shadow 0.2s' : 'none',
        fontFamily: 'system-ui, sans-serif',
        ...appearances[appearance],
        ...style
      }}
      onClick={onSelect}
      onMouseEnter={(e) => {
        if (interactive) e.currentTarget.style.transform = 'translateY(-2px)';
      }}
      onMouseLeave={(e) => {
        if (interactive) e.currentTarget.style.transform = 'translateY(0)';
      }}
    >
      {headerContent && (
        <div style={{ padding: paddings[padding], borderBottom: '1px solid #e5e7eb' }}>
          {headerContent}
        </div>
      )}
      <div style={{ padding: paddings[padding] }}>{children}</div>
      {footerContent && (
        <div style={{ padding: paddings[padding], borderTop: '1px solid #e5e7eb' }}>
          {footerContent}
        </div>
      )}
    </div>
  );
};
