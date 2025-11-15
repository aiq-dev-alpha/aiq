import React from 'react';

export type CardElevation = 'flat' | 'low' | 'medium' | 'high' | 'ultra';
export type CardBorder = 'none' | 'subtle' | 'bold' | 'accent';

interface CardTheme {
  surface: {
    background: string;
    foreground: string;
  };
  border: {
    color: string;
    width: string;
  };
  spacing: {
    padding: string;
  };
  corners: {
    radius: string;
  };
}

interface CardProps {
  children: React.ReactNode;
  elevation?: CardElevation;
  borderStyle?: CardBorder;
  interactive?: boolean;
  header?: React.ReactNode;
  footer?: React.ReactNode;
  cardTheme?: Partial<CardTheme>;
  styles?: React.CSSProperties;
  onClick?: () => void;
}

const defaultCardTheme: CardTheme = {
  surface: {
    background: '#ffffff',
    foreground: '#0f172a'
  },
  border: {
    color: '#e2e8f0',
    width: '1px'
  },
  spacing: {
    padding: '1.5rem'
  },
  corners: {
    radius: '0.75rem'
  }
};

export const Card: React.FC<CardProps> = ({
  children,
  elevation = 'low',
  borderStyle = 'subtle',
  interactive = false,
  header,
  footer,
  cardTheme = {},
  styles = {},
  onClick
}) => {
  const theme = { ...defaultCardTheme, ...cardTheme };

  const elevationMap: Record<CardElevation, string> = {
    flat: 'none',
    low: '0 1px 3px rgba(0, 0, 0, 0.1)',
    medium: '0 4px 6px rgba(0, 0, 0, 0.1)',
    high: '0 10px 15px rgba(0, 0, 0, 0.1)',
    ultra: '0 20px 25px rgba(0, 0, 0, 0.15)'
  };

  const borderMap: Record<CardBorder, string> = {
    none: 'none',
    subtle: `${theme.border.width} solid ${theme.border.color}`,
    bold: `2px solid ${theme.border.color}`,
    accent: `3px solid #3b82f6`
  };

  const containerStyles: React.CSSProperties = {
    backgroundColor: theme.surface.background,
    color: theme.surface.foreground,
    borderRadius: theme.corners.radius,
    boxShadow: elevationMap[elevation],
    border: borderMap[borderStyle],
    overflow: 'hidden',
    transition: interactive ? 'all 0.2s ease' : 'none',
    cursor: interactive ? 'pointer' : 'default',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const headerStyles: React.CSSProperties = {
    padding: theme.spacing.padding,
    borderBottom: `${theme.border.width} solid ${theme.border.color}`,
    fontWeight: 600,
    fontSize: '1.125rem'
  };

  const bodyStyles: React.CSSProperties = {
    padding: theme.spacing.padding
  };

  const footerStyles: React.CSSProperties = {
    padding: theme.spacing.padding,
    borderTop: `${theme.border.width} solid ${theme.border.color}`,
    backgroundColor: `${theme.border.color}50`,
    fontSize: '0.875rem'
  };

  return (
    <div
      style={containerStyles}
      onClick={onClick}
      onMouseEnter={(e) => {
        if (interactive) {
          e.currentTarget.style.transform = 'translateY(-2px)';
          e.currentTarget.style.boxShadow = elevationMap.high;
        }
      }}
      onMouseLeave={(e) => {
        if (interactive) {
          e.currentTarget.style.transform = 'translateY(0)';
          e.currentTarget.style.boxShadow = elevationMap[elevation];
        }
      }}
    >
      {header && <div style={headerStyles}>{header}</div>}
      <div style={bodyStyles}>{children}</div>
      {footer && <div style={footerStyles}>{footer}</div>}
    </div>
  );
};
