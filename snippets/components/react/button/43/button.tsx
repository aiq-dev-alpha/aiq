import React from 'react';

export interface ButtonTheme {
  palette: {
    light: { bg: string; fg: string };
    dark: { bg: string; fg: string };
    colored: { bg: string; fg: string };
  };
  shadows: boolean;
  animations: boolean;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  mode?: 'light' | 'dark' | 'colored';
  density?: 'compact' | 'comfortable' | 'spacious';
  elevation?: 0 | 1 | 2 | 3;
  theme?: Partial<ButtonTheme>;
  prepend?: React.ReactNode;
  append?: React.ReactNode;
  block?: boolean;
  loading?: boolean;
}

const defaultTheme: ButtonTheme = {
  palette: {
    light: { bg: '#f3f4f6', fg: '#111827' },
    dark: { bg: '#1f2937', fg: '#f9fafb' },
    colored: { bg: '#3b82f6', fg: '#ffffff' }
  },
  shadows: true,
  animations: true
};

export const Button: React.FC<ButtonProps> = ({
  mode = 'colored',
  density = 'comfortable',
  elevation = 1,
  theme = {},
  prepend,
  append,
  block = false,
  loading = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const colors = appliedTheme.palette[mode];

  const densityConfig = {
    compact: { padding: '0.5rem 1rem', fontSize: '0.875rem', gap: '0.375rem' },
    comfortable: { padding: '0.75rem 1.5rem', fontSize: '1rem', gap: '0.5rem' },
    spacious: { padding: '1rem 2rem', fontSize: '1.125rem', gap: '0.75rem' }
  };

  const elevationShadows = [
    'none',
    '0 1px 3px rgba(0,0,0,0.12)',
    '0 4px 8px rgba(0,0,0,0.15)',
    '0 8px 16px rgba(0,0,0,0.2)'
  ];

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.bg,
    color: colors.fg,
    border: 'none',
    borderRadius: '0.625rem',
    fontWeight: 600,
    cursor: loading ? 'wait' : 'pointer',
    opacity: loading ? 0.7 : 1,
    transition: appliedTheme.animations ? 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)' : 'none',
    boxShadow: appliedTheme.shadows ? elevationShadows[elevation] : 'none',
    width: block ? '100%' : 'auto',
    ...densityConfig[density],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {loading ? (
        <span style={{ animation: 'spin 1s linear infinite' }}>⏳</span>
      ) : (
        <>
          {prepend && <span style={{ display: 'flex' }}>{prepend}</span>}
          <span>{children}</span>
          {append && <span style={{ display: 'flex' }}>{append}</span>}
        </>
      )}
    </button>
  );
};
