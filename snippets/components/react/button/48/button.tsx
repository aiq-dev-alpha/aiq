import React from 'react';

export interface ButtonTheme {
  brandHue: number;
  saturation: number;
  neutralColor: string;
  fontFamily: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  kind?: 'standard' | 'emphasized' | 'subdued' | 'plain';
  dimension?: 'xs' | 's' | 'm' | 'l' | 'xl';
  rounded?: boolean;
  theme?: Partial<ButtonTheme>;
  leftSlot?: React.ReactNode;
  rightSlot?: React.ReactNode;
  fullSpan?: boolean;
}

const defaultTheme: ButtonTheme = {
  brandHue: 260,
  saturation: 75,
  neutralColor: '#737373',
  fontFamily: 'system-ui, sans-serif'
};

export const Button: React.FC<ButtonProps> = ({
  kind = 'standard',
  dimension = 'm',
  rounded = false,
  theme = {},
  leftSlot,
  rightSlot,
  fullSpan = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const brandColor = `hsl(${appliedTheme.brandHue}, ${appliedTheme.saturation}%, 55%)`;

  const dimensionMap = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.75rem', height: '1.75rem' },
    s: { padding: '0.5rem 1rem', fontSize: '0.875rem', height: '2.25rem' },
    m: { padding: '0.625rem 1.25rem', fontSize: '1rem', height: '2.75rem' },
    l: { padding: '0.75rem 1.5rem', fontSize: '1.125rem', height: '3.25rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.25rem', height: '3.75rem' }
  };

  const kindMap = {
    standard: {
      backgroundColor: brandColor,
      color: '#ffffff',
      border: 'none',
      fontWeight: 600
    },
    emphasized: {
      background: `linear-gradient(135deg, ${brandColor}, hsl(${appliedTheme.brandHue}, ${appliedTheme.saturation}%, 65%))`,
      color: '#ffffff',
      border: 'none',
      fontWeight: 700,
      boxShadow: `0 4px 12px ${brandColor}40`
    },
    subdued: {
      backgroundColor: `${brandColor}20`,
      color: brandColor,
      border: 'none',
      fontWeight: 500
    },
    plain: {
      backgroundColor: 'transparent',
      color: brandColor,
      border: `1px solid ${brandColor}`,
      fontWeight: 500
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    fontFamily: appliedTheme.fontFamily,
    borderRadius: rounded ? '9999px' : '0.5rem',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: fullSpan ? '100%' : 'auto',
    ...dimensionMap[dimension],
    ...kindMap[kind],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {leftSlot && <span style={{ display: 'flex' }}>{leftSlot}</span>}
      <span>{children}</span>
      {rightSlot && <span style={{ display: 'flex' }}>{rightSlot}</span>}
    </button>
  );
};
