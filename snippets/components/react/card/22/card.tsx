import React from 'react';

export interface CardTheme {
  surface: string;
  border: string;
  text: string;
  heading: string;
  shadow: string;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  appearance?: 'flat' | 'raised' | 'bordered' | 'ghost';
  spacing?: 'compact' | 'normal' | 'relaxed';
  theme?: Partial<CardTheme>;
  title?: React.ReactNode;
  actions?: React.ReactNode;
  interactive?: boolean;
  rounded?: boolean;
}

const defaultTheme: CardTheme = {
  surface: '#ffffff',
  border: '#d1d5db',
  text: '#4b5563',
  heading: '#1f2937',
  shadow: 'rgba(0, 0, 0, 0.08)'
};

export const Card: React.FC<CardProps> = ({
  appearance = 'raised',
  spacing = 'normal',
  theme = {},
  title,
  actions,
  interactive = false,
  rounded = true,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const spacingMap = {
    compact: '1rem',
    normal: '1.5rem',
    relaxed: '2rem'
  };

  const appearanceStyles = {
    flat: {
      backgroundColor: appliedTheme.surface,
      border: 'none',
      boxShadow: 'none'
    },
    raised: {
      backgroundColor: appliedTheme.surface,
      border: 'none',
      boxShadow: `0 2px 8px ${appliedTheme.shadow}`
    },
    bordered: {
      backgroundColor: appliedTheme.surface,
      border: `2px solid ${appliedTheme.border}`,
      boxShadow: 'none'
    },
    ghost: {
      backgroundColor: 'transparent',
      border: `1px dashed ${appliedTheme.border}`,
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    borderRadius: rounded ? '1rem' : '0.375rem',
    overflow: 'hidden',
    transition: interactive ? 'transform 0.2s ease, box-shadow 0.2s ease' : 'none',
    cursor: interactive ? 'pointer' : 'default',
    ...appearanceStyles[appearance],
    ...style
  };

  return (
    <div
      style={baseStyles}
      onMouseEnter={(e) => {
        if (interactive) {
          e.currentTarget.style.transform = 'translateY(-4px)';
          e.currentTarget.style.boxShadow = `0 8px 16px ${appliedTheme.shadow}`;
        }
      }}
      onMouseLeave={(e) => {
        if (interactive) {
          e.currentTarget.style.transform = 'translateY(0)';
          e.currentTarget.style.boxShadow = appearanceStyles[appearance].boxShadow || 'none';
        }
      }}
      {...props}
    >
      {title && (
        <div style={{ padding: spacingMap[spacing], borderBottom: `1px solid ${appliedTheme.border}`, color: appliedTheme.heading, fontWeight: 700 }}>
          {title}
        </div>
      )}
      <div style={{ padding: spacingMap[spacing], color: appliedTheme.text }}>
        {children}
      </div>
      {actions && (
        <div style={{ padding: spacingMap[spacing], borderTop: `1px solid ${appliedTheme.border}`, display: 'flex', gap: '0.75rem' }}>
          {actions}
        </div>
      )}
    </div>
  );
};
