import React from 'react';

export interface ButtonTheme {
  colors: Record<string, { bg: string; fg: string; border: string }>;
  sizes: Record<string, { h: string; px: string; text: string }>;
  rounded: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  colorway?: 'blue' | 'green' | 'red' | 'purple' | 'gray';
  styling?: 'solid' | 'outline' | 'soft' | 'ghost';
  sizing?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  theme?: Partial<ButtonTheme>;
  before?: React.ReactNode;
  after?: React.ReactNode;
  expanded?: boolean;
  rounded?: boolean;
}

const defaultTheme: ButtonTheme = {
  colors: {
    blue: { bg: '#3b82f6', fg: '#ffffff', border: '#3b82f6' },
    green: { bg: '#10b981', fg: '#ffffff', border: '#10b981' },
    red: { bg: '#ef4444', fg: '#ffffff', border: '#ef4444' },
    purple: { bg: '#a855f7', fg: '#ffffff', border: '#a855f7' },
    gray: { bg: '#6b7280', fg: '#ffffff', border: '#6b7280' }
  },
  sizes: {
    xs: { h: '1.75rem', px: '0.75rem', text: '0.75rem' },
    sm: { h: '2rem', px: '1rem', text: '0.875rem' },
    md: { h: '2.5rem', px: '1.25rem', text: '1rem' },
    lg: { h: '3rem', px: '1.5rem', text: '1.125rem' },
    xl: { h: '3.5rem', px: '2rem', text: '1.25rem' }
  },
  rounded: '0.5rem'
};

export const Button: React.FC<ButtonProps> = ({
  colorway = 'blue',
  styling = 'solid',
  sizing = 'md',
  theme = {},
  before,
  after,
  expanded = false,
  rounded = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colorConfig = appliedTheme.colors[colorway];
  const sizeConfig = appliedTheme.sizes[sizing];

  const stylingConfig = {
    solid: {
      backgroundColor: colorConfig.bg,
      color: colorConfig.fg,
      border: 'none'
    },
    outline: {
      backgroundColor: 'transparent',
      color: colorConfig.bg,
      border: `2px solid ${colorConfig.border}`
    },
    soft: {
      backgroundColor: `${colorConfig.bg}20`,
      color: colorConfig.bg,
      border: 'none'
    },
    ghost: {
      backgroundColor: 'transparent',
      color: colorConfig.bg,
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    height: sizeConfig.h,
    padding: `0 ${sizeConfig.px}`,
    fontSize: sizeConfig.text,
    fontWeight: 600,
    borderRadius: rounded ? '9999px' : appliedTheme.rounded,
    cursor: 'pointer',
    transition: 'all 0.15s ease',
    width: expanded ? '100%' : 'auto',
    ...stylingConfig[styling],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {before && <span style={{ display: 'flex' }}>{before}</span>}
      <span>{children}</span>
      {after && <span style={{ display: 'flex' }}>{after}</span>}
    </button>
  );
};
