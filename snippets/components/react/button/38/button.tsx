import React from 'react';

export interface ButtonTheme {
  palette: Map<string, string>;
  radius: 'sharp' | 'soft' | 'round' | 'pill';
  weight: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  hue?: 'ocean' | 'forest' | 'sunset' | 'lavender' | 'slate';
  surface?: 'flat' | 'raised' | 'outlined' | 'text';
  scale?: 'micro' | 'mini' | 'midi' | 'maxi' | 'mega';
  theme?: Partial<ButtonTheme>;
  decorLeft?: React.ReactNode;
  decorRight?: React.ReactNode;
  active?: boolean;
  spanning?: boolean;
}

const defaultTheme: ButtonTheme = {
  palette: new Map([
    ['ocean', '#0ea5e9'],
    ['forest', '#22c55e'],
    ['sunset', '#f97316'],
    ['lavender', '#a855f7'],
    ['slate', '#64748b']
  ]),
  radius: 'soft',
  weight: 600
};

export const Button: React.FC<ButtonProps> = ({
  hue = 'ocean',
  surface = 'flat',
  scale = 'midi',
  theme = {},
  decorLeft,
  decorRight,
  active = false,
  spanning = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const hueColor = appliedTheme.palette.get(hue) || '#0ea5e9';

  const radiusMap = {
    sharp: '0',
    soft: '0.5rem',
    round: '0.75rem',
    pill: '9999px'
  };

  const scaleConfig = {
    micro: { padding: '0.25rem 0.5rem', fontSize: '0.75rem', height: '1.5rem' },
    mini: { padding: '0.375rem 0.75rem', fontSize: '0.8125rem', height: '2rem' },
    midi: { padding: '0.5rem 1rem', fontSize: '0.9375rem', height: '2.5rem' },
    maxi: { padding: '0.75rem 1.5rem', fontSize: '1.0625rem', height: '3rem' },
    mega: { padding: '1rem 2rem', fontSize: '1.1875rem', height: '3.5rem' }
  };

  const surfaceConfig = {
    flat: {
      backgroundColor: active ? hueColor : hueColor,
      color: '#ffffff',
      border: 'none',
      boxShadow: 'none'
    },
    raised: {
      backgroundColor: hueColor,
      color: '#ffffff',
      border: 'none',
      boxShadow: '0 2px 8px rgba(0, 0, 0, 0.15)'
    },
    outlined: {
      backgroundColor: active ? `${hueColor}10` : 'transparent',
      color: hueColor,
      border: `2px solid ${hueColor}`,
      boxShadow: 'none'
    },
    text: {
      backgroundColor: active ? `${hueColor}15` : 'transparent',
      color: hueColor,
      border: 'none',
      boxShadow: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: radiusMap[appliedTheme.radius],
    fontWeight: appliedTheme.weight,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: spanning ? '100%' : 'auto',
    ...scaleConfig[scale],
    ...surfaceConfig[surface],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {decorLeft && <span style={{ display: 'flex' }}>{decorLeft}</span>}
      <span>{children}</span>
      {decorRight && <span style={{ display: 'flex' }}>{decorRight}</span>}
    </button>
  );
};
