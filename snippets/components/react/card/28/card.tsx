import React from 'react';

export interface CardTheme {
  backgroundColor: string;
  borderColor: string;
  textColor: string;
  shadowColor: string;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'outlined' | 'elevated';
  padding?: 'sm' | 'md' | 'lg';
  theme?: Partial<CardTheme>;
  header?: React.ReactNode;
  footer?: React.ReactNode;
}

const defaultTheme: CardTheme = {
  backgroundColor: '#ffffff',
  borderColor: '#e5e7eb',
  textColor: '#374151',
  shadowColor: 'rgba(0, 0, 0, 0.1)'
};

export const Card: React.FC<CardProps> = ({
  variant = 'default',
  padding = 'md',
  theme = {},
  header,
  footer,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const paddingMap = {
    sm: '1rem',
    md: '1.5rem',
    lg: '2rem'
  };

  const variantMap = {
    default: {
      backgroundColor: appliedTheme.backgroundColor,
      border: `1px solid ${appliedTheme.borderColor}`,
      boxShadow: 'none'
    },
    outlined: {
      backgroundColor: appliedTheme.backgroundColor,
      border: `2px solid ${appliedTheme.borderColor}`,
      boxShadow: 'none'
    },
    elevated: {
      backgroundColor: appliedTheme.backgroundColor,
      border: 'none',
      boxShadow: `0 4px 12px ${appliedTheme.shadowColor}`
    }
  };

  const cardStyles: React.CSSProperties = {
    borderRadius: '0.75rem',
    overflow: 'hidden',
    color: appliedTheme.textColor,
    ...variantMap[variant],
    ...style
  };

  return (
    <div style={cardStyles} {...props}>
      {header && <div style={{ padding: paddingMap[padding], borderBottom: `1px solid ${appliedTheme.borderColor}`, fontWeight: 700 }}>{header}</div>}
      <div style={{ padding: paddingMap[padding] }}>{children}</div>
      {footer && <div style={{ padding: paddingMap[padding], borderTop: `1px solid ${appliedTheme.borderColor}` }}>{footer}</div>}
    </div>
  );
};
