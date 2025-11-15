import React from 'react';

export interface ButtonTheme {
  hue: number;
  saturation: number;
  lightness: number;
  fontStack: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  design?: 'classic' | 'modern' | 'neo' | 'retro';
  weight?: 'light' | 'regular' | 'heavy';
  theme?: Partial<ButtonTheme>;
  icon?: React.ReactNode;
  badge?: string | number;
  width?: 'auto' | 'full' | 'fit';
}

const defaultTheme: ButtonTheme = {
  hue: 200,
  saturation: 80,
  lightness: 50,
  fontStack: '-apple-system, BlinkMacSystemFont, sans-serif'
};

export const Button: React.FC<ButtonProps> = ({
  design = 'modern',
  weight = 'regular',
  theme = {},
  icon,
  badge,
  width = 'auto',
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const baseColor = `hsl(${appliedTheme.hue}, ${appliedTheme.saturation}%, ${appliedTheme.lightness}%)`;

  const weightMap = {
    light: { padding: '0.5rem 1rem', fontSize: '0.875rem', fontWeight: 400 },
    regular: { padding: '0.75rem 1.5rem', fontSize: '1rem', fontWeight: 500 },
    heavy: { padding: '1rem 2rem', fontSize: '1.125rem', fontWeight: 700 }
  };

  const designMap = {
    classic: {
      background: baseColor,
      border: 'none',
      borderRadius: '4px',
      boxShadow: '0 2px 4px rgba(0,0,0,0.2)'
    },
    modern: {
      background: baseColor,
      border: 'none',
      borderRadius: '12px',
      boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
    },
    neo: {
      background: baseColor,
      border: `3px solid ${baseColor}`,
      borderRadius: '8px',
      boxShadow: `4px 4px 0 ${baseColor}80`
    },
    retro: {
      background: baseColor,
      border: `4px solid #000`,
      borderRadius: '0',
      boxShadow: '4px 4px 0 #000'
    }
  };

  const widthMap = {
    auto: 'auto',
    full: '100%',
    fit: 'fit-content'
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    position: 'relative',
    color: '#ffffff',
    fontFamily: appliedTheme.fontStack,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: widthMap[width],
    ...weightMap[weight],
    ...designMap[design],
    ...style
  };

  const badgeStyles: React.CSSProperties = {
    position: 'absolute',
    top: '-8px',
    right: '-8px',
    backgroundColor: '#ef4444',
    color: '#fff',
    borderRadius: '9999px',
    padding: '0.125rem 0.375rem',
    fontSize: '0.75rem',
    fontWeight: 700
  };

  return (
    <button style={baseStyles} {...props}>
      {icon && <span style={{ display: 'flex' }}>{icon}</span>}
      <span>{children}</span>
      {badge && <span style={badgeStyles}>{badge}</span>}
    </button>
  );
};
