import React from 'react';

type Style = 'filled' | 'tonal' | 'outlined' | 'text';
type Density = 'dense' | 'regular' | 'relaxed';

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  buttonStyle?: Style;
  density?: Density;
  expand?: boolean;
  loading?: boolean;
  iconStart?: React.ReactNode;
  iconEnd?: React.ReactNode;
}

export const Button: React.FC<Props> = ({
  children,
  buttonStyle = 'filled',
  density = 'regular',
  expand = false,
  loading = false,
  iconStart,
  iconEnd,
  disabled,
  style,
  ...props
}) => {
  const baseColor = '#ec4899';

  const styles: Record<Style, React.CSSProperties> = {
    filled: { background: baseColor, color: '#fff', border: 'none', boxShadow: '0 2px 4px rgba(0,0,0,0.1)' },
    tonal: { background: `${baseColor}25`, color: baseColor, border: 'none' },
    outlined: { background: 'transparent', color: baseColor, border: `2px solid ${baseColor}` },
    text: { background: 'transparent', color: baseColor, border: 'none' }
  };

  const densities: Record<Density, React.CSSProperties> = {
    dense: { padding: '0.5rem 0.875rem', fontSize: '0.875rem', minHeight: '2rem' },
    regular: { padding: '0.75rem 1.25rem', fontSize: '1rem', minHeight: '2.75rem' },
    relaxed: { padding: '1rem 1.75rem', fontSize: '1.125rem', minHeight: '3.5rem' }
  };

  return (
    <button
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.5rem',
        borderRadius: '0.5rem',
        fontWeight: 500,
        cursor: disabled || loading ? 'not-allowed' : 'pointer',
        opacity: disabled || loading ? 0.5 : 1,
        transition: 'all 0.2s',
        width: expand ? '100%' : 'auto',
        justifyContent: 'center',
        fontFamily: 'system-ui, sans-serif',
        ...densities[density],
        ...styles[buttonStyle],
        ...style
      }}
      disabled={disabled || loading}
      {...props}
    >
      {loading ? '⌛' : iconStart}
      {!loading && children}
      {!loading && iconEnd}
    </button>
  );
};
