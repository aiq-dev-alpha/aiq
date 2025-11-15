import React from 'react';

type Appearance = 'primary' | 'secondary' | 'success' | 'danger' | 'warning';
type Scale = 'xs' | 'sm' | 'base' | 'lg' | 'xl' | '2xl';

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  appearance?: Appearance;
  scale?: Scale;
  fullWidth?: boolean;
  loading?: boolean;
  leftElement?: React.ReactNode;
  rightElement?: React.ReactNode;
}

export const Button: React.FC<Props> = ({
  children,
  appearance = 'primary',
  scale = 'base',
  fullWidth = false,
  loading = false,
  leftElement,
  rightElement,
  disabled,
  style,
  ...props
}) => {
  const appearances: Record<Appearance, React.CSSProperties> = {
    primary: { background: '#6366f1', color: '#fff', border: 'none' },
    secondary: { background: '#64748b', color: '#fff', border: 'none' },
    success: { background: '#10b981', color: '#fff', border: 'none' },
    danger: { background: '#ef4444', color: '#fff', border: 'none' },
    warning: { background: '#f59e0b', color: '#fff', border: 'none' }
  };

  const scales: Record<Scale, React.CSSProperties> = {
    xs: { padding: '0.25rem 0.625rem', fontSize: '0.75rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    base: { padding: '0.625rem 1.25rem', fontSize: '1rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.125rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.25rem' },
    '2xl': { padding: '1.25rem 2.5rem', fontSize: '1.5rem' }
  };

  return (
    <button
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '0.5rem',
        borderRadius: '0.5rem',
        fontWeight: 600,
        cursor: disabled || loading ? 'not-allowed' : 'pointer',
        opacity: disabled || loading ? 0.6 : 1,
        transition: 'all 0.2s',
        width: fullWidth ? '100%' : 'auto',
        fontFamily: 'system-ui, sans-serif',
        ...scales[scale],
        ...appearances[appearance],
        ...style
      }}
      disabled={disabled || loading}
      {...props}
    >
      {loading ? '⏳' : leftElement}
      {!loading && children}
      {!loading && rightElement}
    </button>
  );
};
