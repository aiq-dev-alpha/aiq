import React from 'react';

export interface CardTheme {
  surfaceColor: string;
  borderColor: string;
  textColor: string;
  accentColor: string;
  shadowColor: string;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  style?: 'default' | 'outlined' | 'elevated' | 'ghost';
  size?: 'compact' | 'default' | 'large';
  theme?: Partial<CardTheme>;
  title?: React.ReactNode;
  subtitle?: string;
  actions?: React.ReactNode;
  clickable?: boolean;
  rounded?: 'sm' | 'md' | 'lg' | 'xl';
}

const defaultTheme: CardTheme = {
  surfaceColor: '#ffffff',
  borderColor: '#d1d5db',
  textColor: '#374151',
  accentColor: '#6366f1',
  shadowColor: 'rgba(0, 0, 0, 0.1)'
};

export const Card: React.FC<CardProps> = ({
  style: cardStyle = 'default',
  size = 'default',
  theme = {},
  title,
  subtitle,
  actions,
  clickable = false,
  rounded = 'md',
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeMap = {
    compact: '1rem',
    default: '1.5rem',
    large: '2rem'
  };

  const roundedMap = {
    sm: '0.375rem',
    md: '0.5rem',
    lg: '0.75rem',
    xl: '1rem'
  };

  const styleMap = {
    default: {
      backgroundColor: appliedTheme.surfaceColor,
      border: `1px solid ${appliedTheme.borderColor}`,
      boxShadow: 'none'
    },
    outlined: {
      backgroundColor: appliedTheme.surfaceColor,
      border: `2px solid ${appliedTheme.accentColor}`,
      boxShadow: 'none'
    },
    elevated: {
      backgroundColor: appliedTheme.surfaceColor,
      border: 'none',
      boxShadow: `0 4px 12px ${appliedTheme.shadowColor}`
    },
    ghost: {
      backgroundColor: 'transparent',
      border: `1px dashed ${appliedTheme.borderColor}`,
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    borderRadius: roundedMap[rounded],
    overflow: 'hidden',
    transition: clickable ? 'all 0.2s ease' : 'none',
    cursor: clickable ? 'pointer' : 'default',
    ...styleMap[cardStyle],
    ...style
  };

  return (
    <div style={baseStyles} {...props}>
      {(title || subtitle) && (
        <div style={{ padding: sizeMap[size], borderBottom: `1px solid ${appliedTheme.borderColor}` }}>
          {title && <h3 style={{ margin: 0, fontSize: '1.125rem', fontWeight: 700, color: appliedTheme.textColor }}>{title}</h3>}
          {subtitle && <p style={{ margin: '0.25rem 0 0 0', fontSize: '0.875rem', color: appliedTheme.textColor, opacity: 0.7 }}>{subtitle}</p>}
        </div>
      )}
      <div style={{ padding: sizeMap[size], color: appliedTheme.textColor }}>
        {children}
      </div>
      {actions && (
        <div style={{ padding: sizeMap[size], borderTop: `1px solid ${appliedTheme.borderColor}`, display: 'flex', gap: '0.75rem', justifyContent: 'flex-end' }}>
          {actions}
        </div>
      )}
    </div>
  );
};
