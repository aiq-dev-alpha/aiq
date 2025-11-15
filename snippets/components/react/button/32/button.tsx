import React from 'react';

export interface ButtonTheme {
  baseHue: number;
  saturation: number;
  lightness: number;
  borderWidth: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  mode?: 'fill' | 'stroke' | 'ghost' | 'glow';
  scale?: 'xs' | 's' | 'm' | 'l' | 'xl';
  theme?: Partial<ButtonTheme>;
  leadingIcon?: React.ReactNode;
  trailingIcon?: React.ReactNode;
  stretch?: boolean;
  pill?: boolean;
}

const defaultTheme: ButtonTheme = {
  baseHue: 280,
  saturation: 70,
  lightness: 55,
  borderWidth: 2
};

export const Button: React.FC<ButtonProps> = ({
  mode = 'fill',
  scale = 'm',
  theme = {},
  leadingIcon,
  trailingIcon,
  stretch = false,
  pill = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const baseColor = `hsl(${appliedTheme.baseHue}, ${appliedTheme.saturation}%, ${appliedTheme.lightness}%)`;
  const hoverColor = `hsl(${appliedTheme.baseHue}, ${appliedTheme.saturation}%, ${appliedTheme.lightness - 5}%)`;

  const scaleConfig = {
    xs: { padding: '0.375rem 0.625rem', fontSize: '0.75rem' },
    s: { padding: '0.5rem 0.875rem', fontSize: '0.875rem' },
    m: { padding: '0.625rem 1.125rem', fontSize: '1rem' },
    l: { padding: '0.75rem 1.375rem', fontSize: '1.125rem' },
    xl: { padding: '0.875rem 1.625rem', fontSize: '1.25rem' }
  };

  const modeConfig = {
    fill: {
      backgroundColor: baseColor,
      color: '#ffffff',
      border: 'none',
      boxShadow: 'none'
    },
    stroke: {
      backgroundColor: 'transparent',
      color: baseColor,
      border: `${appliedTheme.borderWidth}px solid ${baseColor}`,
      boxShadow: 'none'
    },
    ghost: {
      backgroundColor: `${baseColor}15`,
      color: baseColor,
      border: 'none',
      boxShadow: 'none'
    },
    glow: {
      backgroundColor: baseColor,
      color: '#ffffff',
      border: 'none',
      boxShadow: `0 0 20px ${baseColor}60`
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: pill ? '9999px' : '0.625rem',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    width: stretch ? '100%' : 'auto',
    ...scaleConfig[scale],
    ...modeConfig[mode],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {leadingIcon && <span style={{ display: 'flex' }}>{leadingIcon}</span>}
      {children}
      {trailingIcon && <span style={{ display: 'flex' }}>{trailingIcon}</span>}
    </button>
  );
};
