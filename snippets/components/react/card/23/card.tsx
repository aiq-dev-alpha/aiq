import React from 'react';

export interface CardTheme {
  background: string;
  border: string;
  text: string;
  heading: string;
  accent: string;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  elevation?: 0 | 1 | 2 | 3 | 4;
  padding?: 'none' | 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  theme?: Partial<CardTheme>;
  headerContent?: React.ReactNode;
  footerContent?: React.ReactNode;
  isInteractive?: boolean;
  hasBorder?: boolean;
}

const defaultTheme: CardTheme = {
  background: '#ffffff',
  border: '#e2e8f0',
  text: '#475569',
  heading: '#0f172a',
  accent: '#3b82f6'
};

export const Card: React.FC<CardProps> = ({
  elevation = 1,
  padding = 'md',
  theme = {},
  headerContent,
  footerContent,
  isInteractive = false,
  hasBorder = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const elevationMap = {
    0: 'none',
    1: '0 1px 3px rgba(0, 0, 0, 0.1)',
    2: '0 4px 6px rgba(0, 0, 0, 0.1)',
    3: '0 10px 15px rgba(0, 0, 0, 0.1)',
    4: '0 20px 25px rgba(0, 0, 0, 0.15)'
  };

  const paddingMap = {
    none: '0',
    xs: '0.5rem',
    sm: '1rem',
    md: '1.5rem',
    lg: '2rem',
    xl: '3rem'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.background,
    borderRadius: '1rem',
    border: hasBorder ? `1px solid ${appliedTheme.border}` : 'none',
    boxShadow: elevationMap[elevation],
    overflow: 'hidden',
    transition: isInteractive ? 'all 0.3s ease' : 'none',
    cursor: isInteractive ? 'pointer' : 'default',
    ...style
  };

  return (
    <div
      style={cardStyles}
      onMouseEnter={(e) => {
        if (isInteractive) {
          e.currentTarget.style.transform = 'translateY(-4px)';
          e.currentTarget.style.boxShadow = '0 12px 20px rgba(0, 0, 0, 0.15)';
        }
      }}
      onMouseLeave={(e) => {
        if (isInteractive) {
          e.currentTarget.style.transform = 'translateY(0)';
          e.currentTarget.style.boxShadow = elevationMap[elevation];
        }
      }}
      {...props}
    >
      {headerContent && (
        <div style={{
          padding: paddingMap[padding],
          borderBottom: `1px solid ${appliedTheme.border}`,
          fontWeight: 700,
          color: appliedTheme.heading
        }}>
          {headerContent}
        </div>
      )}
      <div style={{ padding: paddingMap[padding], color: appliedTheme.text }}>
        {children}
      </div>
      {footerContent && (
        <div style={{
          padding: paddingMap[padding],
          borderTop: `1px solid ${appliedTheme.border}`,
          backgroundColor: `${appliedTheme.border}30`
        }}>
          {footerContent}
        </div>
      )}
    </div>
  );
};
