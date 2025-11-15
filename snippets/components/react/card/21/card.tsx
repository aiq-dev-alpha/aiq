import React from 'react';

export interface CardTheme {
  backgroundColor: string;
  borderColor: string;
  shadowColor: string;
  textColor: string;
  headingColor: string;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'elevated' | 'outlined' | 'filled';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  theme?: Partial<CardTheme>;
  header?: React.ReactNode;
  footer?: React.ReactNode;
  hoverable?: boolean;
}

const defaultTheme: CardTheme = {
  backgroundColor: '#ffffff',
  borderColor: '#e5e7eb',
  shadowColor: 'rgba(0, 0, 0, 0.1)',
  textColor: '#6b7280',
  headingColor: '#111827'
};

export const Card: React.FC<CardProps> = ({
  variant = 'elevated',
  padding = 'md',
  theme = {},
  header,
  footer,
  hoverable = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const paddingMap = {
    none: '0',
    sm: '0.75rem',
    md: '1.25rem',
    lg: '1.75rem',
    xl: '2.5rem'
  };

  const variantStyles = {
    elevated: {
      backgroundColor: appliedTheme.backgroundColor,
      border: 'none',
      boxShadow: `0 4px 12px ${appliedTheme.shadowColor}`
    },
    outlined: {
      backgroundColor: appliedTheme.backgroundColor,
      border: `1px solid ${appliedTheme.borderColor}`,
      boxShadow: 'none'
    },
    filled: {
      backgroundColor: '#f9fafb',
      border: 'none',
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    borderRadius: '0.75rem',
    color: appliedTheme.textColor,
    transition: hoverable ? 'all 0.2s ease' : 'none',
    cursor: hoverable ? 'pointer' : 'default',
    ...variantStyles[variant],
    ...style
  };

  const contentStyles: React.CSSProperties = {
    padding: paddingMap[padding]
  };

  return (
    <div style={baseStyles} {...props}>
      {header && (
        <div style={{ padding: paddingMap[padding], borderBottom: `1px solid ${appliedTheme.borderColor}` }}>
          {header}
        </div>
      )}
      <div style={contentStyles}>{children}</div>
      {footer && (
        <div style={{ padding: paddingMap[padding], borderTop: `1px solid ${appliedTheme.borderColor}` }}>
          {footer}
        </div>
      )}
    </div>
  );
};
