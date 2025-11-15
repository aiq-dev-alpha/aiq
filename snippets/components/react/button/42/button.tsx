import React from 'react';

export interface ButtonTheme {
  accentGradient: [string, string];
  surfaceGradient: [string, string];
  textLight: string;
  textDark: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  tier?: 'primary' | 'secondary' | 'accent' | 'neutral';
  shape?: 'square' | 'rounded' | 'pill' | 'circle';
  theme?: Partial<ButtonTheme>;
  adornmentStart?: React.ReactNode;
  adornmentEnd?: React.ReactNode;
  glowing?: boolean;
  stretched?: boolean;
}

const defaultTheme: ButtonTheme = {
  accentGradient: ['#ec4899', '#f43f5e'],
  surfaceGradient: ['#6366f1', '#8b5cf6'],
  textLight: '#ffffff',
  textDark: '#1f2937'
};

export const Button: React.FC<ButtonProps> = ({
  tier = 'primary',
  shape = 'rounded',
  theme = {},
  adornmentStart,
  adornmentEnd,
  glowing = false,
  stretched = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const tierConfig = {
    primary: {
      background: `linear-gradient(135deg, ${appliedTheme.accentGradient[0]}, ${appliedTheme.accentGradient[1]})`,
      color: appliedTheme.textLight
    },
    secondary: {
      background: `linear-gradient(135deg, ${appliedTheme.surfaceGradient[0]}, ${appliedTheme.surfaceGradient[1]})`,
      color: appliedTheme.textLight
    },
    accent: {
      background: '#fbbf24',
      color: appliedTheme.textDark
    },
    neutral: {
      background: '#9ca3af',
      color: appliedTheme.textLight
    }
  };

  const shapeConfig = {
    square: '0',
    rounded: '0.5rem',
    pill: '9999px',
    circle: '50%'
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.625rem',
    padding: shape === 'circle' ? '1rem' : '0.75rem 1.5rem',
    border: 'none',
    borderRadius: shapeConfig[shape],
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.3s ease',
    width: stretched ? '100%' : shape === 'circle' ? '3rem' : 'auto',
    height: shape === 'circle' ? '3rem' : 'auto',
    boxShadow: glowing ? `0 0 20px ${tierConfig[tier].background}60` : 'none',
    ...tierConfig[tier],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {adornmentStart && <span style={{ display: 'flex' }}>{adornmentStart}</span>}
      {shape !== 'circle' && <span>{children}</span>}
      {shape === 'circle' && (adornmentStart || children)}
      {adornmentEnd && <span style={{ display: 'flex' }}>{adornmentEnd}</span>}
    </button>
  );
};
