import React from 'react';

export interface ButtonTheme {
  baseHue: number;
  neutralShade: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  chromatic?: 'monochrome' | 'vibrant' | 'pastel' | 'neon';
  profile?: 'flat' | 'raised' | 'pressed' | 'floating';
  scale?: 'micro' | 'small' | 'base' | 'large' | 'macro';
  theme?: Partial<ButtonTheme>;
  decoration?: React.ReactNode;
  expand?: boolean;
}

const defaultTheme: ButtonTheme = {
  baseHue: 180,
  neutralShade: '#6b7280'
};

export const Button: React.FC<ButtonProps> = ({
  chromatic = 'vibrant',
  profile = 'raised',
  scale = 'base',
  theme = {},
  decoration,
  expand = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const chromaticMap = {
    monochrome: appliedTheme.neutralShade,
    vibrant: `hsl(${appliedTheme.baseHue}, 85%, 50%)`,
    pastel: `hsl(${appliedTheme.baseHue}, 60%, 75%)`,
    neon: `hsl(${appliedTheme.baseHue}, 100%, 60%)`
  };

  const profileMap = {
    flat: { boxShadow: 'none', transform: 'none' },
    raised: { boxShadow: '0 2px 8px rgba(0,0,0,0.15)', transform: 'none' },
    pressed: { boxShadow: 'inset 0 2px 4px rgba(0,0,0,0.2)', transform: 'translateY(1px)' },
    floating: { boxShadow: '0 10px 25px rgba(0,0,0,0.25)', transform: 'none' }
  };

  const scaleMap = {
    micro: { padding: '0.25rem 0.5rem', fontSize: '0.75rem' },
    small: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    base: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
    large: { padding: '1rem 2rem', fontSize: '1.25rem' },
    macro: { padding: '1.25rem 2.5rem', fontSize: '1.5rem' }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    backgroundColor: chromaticMap[chromatic],
    color: chromatic === 'pastel' ? '#1f2937' : '#ffffff',
    border: 'none',
    borderRadius: '0.5rem',
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: expand ? '100%' : 'auto',
    ...scaleMap[scale],
    ...profileMap[profile],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {decoration && <span style={{ display: 'flex' }}>{decoration}</span>}
      <span>{children}</span>
    </button>
  );
};
