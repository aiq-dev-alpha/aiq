import React from 'react';

export interface ButtonTheme {
  scheme: {
    light: { bg: string; fg: string; border: string };
    dark: { bg: string; fg: string; border: string };
  };
  mode: 'light' | 'dark';
  curve: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  flavor?: 'standard' | 'alternative' | 'special';
  form?: 'block' | 'inline' | 'ghost' | 'link';
  volume?: 'xs' | 'sm' | 'base' | 'lg' | 'xl';
  theme?: Partial<ButtonTheme>;
  startDecor?: React.ReactNode;
  endDecor?: React.ReactNode;
  waiting?: boolean;
  stretched?: boolean;
}

const defaultTheme: ButtonTheme = {
  scheme: {
    light: { bg: '#2563eb', fg: '#ffffff', border: '#1e40af' },
    dark: { bg: '#60a5fa', fg: '#1e3a8a', border: '#3b82f6' }
  },
  mode: 'light',
  curve: 8
};

export const Button: React.FC<ButtonProps> = ({
  flavor = 'standard',
  form = 'block',
  volume = 'base',
  theme = {},
  startDecor,
  endDecor,
  waiting = false,
  stretched = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colors = appliedTheme.scheme[appliedTheme.mode];

  const volumeConfig = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.8125rem', lineHeight: '1.25rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.9375rem', lineHeight: '1.5rem' },
    base: { padding: '0.625rem 1.25rem', fontSize: '1rem', lineHeight: '1.5rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.0625rem', lineHeight: '1.75rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.125rem', lineHeight: '1.75rem' }
  };

  const formConfig = {
    block: {
      backgroundColor: colors.bg,
      color: colors.fg,
      border: 'none'
    },
    inline: {
      backgroundColor: 'transparent',
      color: colors.bg,
      border: `2px solid ${colors.border}`
    },
    ghost: {
      backgroundColor: `${colors.bg}12`,
      color: colors.bg,
      border: `1px solid ${colors.bg}25`
    },
    link: {
      backgroundColor: 'transparent',
      color: colors.bg,
      border: 'none',
      textDecoration: 'underline'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: `${appliedTheme.curve}px`,
    fontWeight: 600,
    cursor: waiting ? 'wait' : 'pointer',
    opacity: waiting ? 0.65 : 1,
    transition: 'all 0.2s ease',
    width: stretched ? '100%' : 'auto',
    ...volumeConfig[volume],
    ...formConfig[form],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {waiting ? '⏳' : startDecor && <span style={{ display: 'flex' }}>{startDecor}</span>}
      <span>{children}</span>
      {!waiting && endDecor && <span style={{ display: 'flex' }}>{endDecor}</span>}
    </button>
  );
};
