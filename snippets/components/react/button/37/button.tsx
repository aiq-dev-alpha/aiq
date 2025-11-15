import React from 'react';

export interface ButtonTheme {
  spectrum: {
    primary: [string, string, string];
    accent: [string, string, string];
    danger: [string, string, string];
  };
  typeface: string;
  corner: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  shade?: 'primary' | 'accent' | 'danger';
  look?: 'solid' | 'hollow' | 'ghost' | 'gradient';
  proportion?: 'xs' | 's' | 'm' | 'l' | 'xl';
  theme?: Partial<ButtonTheme>;
  leadIcon?: React.ReactNode;
  tailIcon?: React.ReactNode;
  processing?: boolean;
  fullSpan?: boolean;
}

const defaultTheme: ButtonTheme = {
  spectrum: {
    primary: ['#3b82f6', '#2563eb', '#1d4ed8'],
    accent: ['#10b981', '#059669', '#047857'],
    danger: ['#ef4444', '#dc2626', '#b91c1c']
  },
  typeface: 'system-ui, sans-serif',
  corner: 6
};

export const Button: React.FC<ButtonProps> = ({
  shade = 'primary',
  look = 'solid',
  proportion = 'm',
  theme = {},
  leadIcon,
  tailIcon,
  processing = false,
  fullSpan = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const [baseColor, hoverColor, activeColor] = appliedTheme.spectrum[shade];

  const proportionConfig = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.8125rem', gap: '0.375rem' },
    s: { padding: '0.5rem 1rem', fontSize: '0.9375rem', gap: '0.5rem' },
    m: { padding: '0.625rem 1.25rem', fontSize: '1rem', gap: '0.625rem' },
    l: { padding: '0.75rem 1.5rem', fontSize: '1.0625rem', gap: '0.75rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.125rem', gap: '1rem' }
  };

  const lookConfig = {
    solid: {
      background: baseColor,
      color: '#ffffff',
      border: 'none'
    },
    hollow: {
      background: 'transparent',
      color: baseColor,
      border: `2px solid ${baseColor}`
    },
    ghost: {
      background: `${baseColor}10`,
      color: baseColor,
      border: `1px solid ${baseColor}30`
    },
    gradient: {
      background: `linear-gradient(135deg, ${baseColor}, ${hoverColor})`,
      color: '#ffffff',
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: `${appliedTheme.corner}px`,
    fontFamily: appliedTheme.typeface,
    fontWeight: 600,
    cursor: processing ? 'wait' : 'pointer',
    opacity: processing ? 0.6 : 1,
    transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
    width: fullSpan ? '100%' : 'auto',
    ...proportionConfig[proportion],
    ...lookConfig[look],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {processing ? '⌛' : leadIcon && <span style={{ display: 'flex' }}>{leadIcon}</span>}
      <span>{children}</span>
      {!processing && tailIcon && <span style={{ display: 'flex' }}>{tailIcon}</span>}
    </button>
  );
};
