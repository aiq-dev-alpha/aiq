import React from 'react';

export interface ButtonTheme {
  primary: { base: string; light: string; dark: string };
  secondary: { base: string; light: string; dark: string };
  spacing: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  level?: 'primary' | 'secondary';
  treatment?: 'default' | 'ghost' | 'link' | 'danger';
  density?: 'tight' | 'normal' | 'loose';
  theme?: Partial<ButtonTheme>;
  before?: React.ReactNode;
  after?: React.ReactNode;
  fluid?: boolean;
}

const defaultTheme: ButtonTheme = {
  primary: { base: '#0891b2', light: '#06b6d4', dark: '#0e7490' },
  secondary: { base: '#64748b', light: '#94a3b8', dark: '#475569' },
  spacing: 4
};

export const Button: React.FC<ButtonProps> = ({
  level = 'primary',
  treatment = 'default',
  density = 'normal',
  theme = {},
  before,
  after,
  fluid = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colors = appliedTheme[level];
  const unit = appliedTheme.spacing;

  const densityMap = {
    tight: { padding: `${unit}px ${unit * 2}px`, fontSize: '0.875rem' },
    normal: { padding: `${unit * 2}px ${unit * 4}px`, fontSize: '1rem' },
    loose: { padding: `${unit * 3}px ${unit * 6}px`, fontSize: '1.125rem' }
  };

  const treatmentMap = {
    default: {
      backgroundColor: colors.base,
      color: '#ffffff',
      border: 'none'
    },
    ghost: {
      backgroundColor: `${colors.base}15`,
      color: colors.dark,
      border: `1px solid ${colors.base}30`
    },
    link: {
      backgroundColor: 'transparent',
      color: colors.base,
      border: 'none',
      textDecoration: 'underline'
    },
    danger: {
      backgroundColor: '#dc2626',
      color: '#ffffff',
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: `${unit * 2}px`,
    borderRadius: `${unit}px`,
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: fluid ? '100%' : 'auto',
    ...densityMap[density],
    ...treatmentMap[treatment],
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
