import React from 'react';

export interface ButtonTheme {
  colors: Map<string, { primary: string; secondary: string }>;
  borderRadius: number;
  fontWeight: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  shade?: 'cyan' | 'magenta' | 'yellow' | 'lime' | 'amber';
  presentation?: 'solid' | 'gradient' | 'outline' | 'dashed' | 'link';
  volume?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  theme?: Partial<ButtonTheme>;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  busy?: boolean;
  spanning?: boolean;
}

const defaultTheme: ButtonTheme = {
  colors: new Map([
    ['cyan', { primary: '#06b6d4', secondary: '#0891b2' }],
    ['magenta', { primary: '#ec4899', secondary: '#db2777' }],
    ['yellow', { primary: '#eab308', secondary: '#ca8a04' }],
    ['lime', { primary: '#84cc16', secondary: '#65a30d' }],
    ['amber', { primary: '#f59e0b', secondary: '#d97706' }]
  ]),
  borderRadius: 6,
  fontWeight: 600
};

export const Button: React.FC<ButtonProps> = ({
  shade = 'cyan',
  presentation = 'solid',
  volume = 'md',
  theme = {},
  leftIcon,
  rightIcon,
  busy = false,
  spanning = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const shadeColors = appliedTheme.colors.get(shade) || { primary: '#06b6d4', secondary: '#0891b2' };

  const volumeMap = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.8125rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.9375rem' },
    md: { padding: '0.625rem 1.25rem', fontSize: '1rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.0625rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.125rem' }
  };

  const presentationMap = {
    solid: {
      background: shadeColors.primary,
      color: '#ffffff',
      border: 'none'
    },
    gradient: {
      background: `linear-gradient(90deg, ${shadeColors.primary}, ${shadeColors.secondary})`,
      color: '#ffffff',
      border: 'none'
    },
    outline: {
      background: 'transparent',
      color: shadeColors.primary,
      border: `2px solid ${shadeColors.primary}`
    },
    dashed: {
      background: 'transparent',
      color: shadeColors.primary,
      border: `2px dashed ${shadeColors.primary}`
    },
    link: {
      background: 'transparent',
      color: shadeColors.primary,
      border: 'none',
      textDecoration: 'underline'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: `${appliedTheme.borderRadius}px`,
    fontWeight: appliedTheme.fontWeight,
    cursor: busy ? 'wait' : 'pointer',
    opacity: busy ? 0.65 : 1,
    transition: 'all 0.2s ease',
    width: spanning ? '100%' : 'auto',
    ...volumeMap[volume],
    ...presentationMap[presentation],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {busy ? '⏳' : leftIcon && <span style={{ display: 'flex' }}>{leftIcon}</span>}
      <span>{children}</span>
      {!busy && rightIcon && <span style={{ display: 'flex' }}>{rightIcon}</span>}
    </button>
  );
};
