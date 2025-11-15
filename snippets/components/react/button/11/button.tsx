import React from 'react';

type Preset = 'default' | 'destructive' | 'constructive' | 'neutral' | 'accent';
type Size = 'compact' | 'normal' | 'comfortable' | 'spacious';

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  preset?: Preset;
  size?: Size;
  fluid?: boolean;
  working?: boolean;
  before?: React.ReactNode;
  after?: React.ReactNode;
}

export const Button: React.FC<Props> = ({
  children,
  preset = 'default',
  size = 'normal',
  fluid = false,
  working = false,
  before,
  after,
  disabled,
  style,
  ...props
}) => {
  const presets: Record<Preset, React.CSSProperties> = {
    default: { background: '#3b82f6', color: '#fff', border: 'none' },
    destructive: { background: '#dc2626', color: '#fff', border: 'none' },
    constructive: { background: '#16a34a', color: '#fff', border: 'none' },
    neutral: { background: '#737373', color: '#fff', border: 'none' },
    accent: { background: '#d946ef', color: '#fff', border: 'none' }
  };

  const sizes: Record<Size, React.CSSProperties> = {
    compact: { padding: '0.375rem 0.875rem', fontSize: '0.813rem' },
    normal: { padding: '0.625rem 1.25rem', fontSize: '0.938rem' },
    comfortable: { padding: '0.875rem 1.75rem', fontSize: '1rem' },
    spacious: { padding: '1.125rem 2.25rem', fontSize: '1.125rem' }
  };

  return (
    <button
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.625rem',
        borderRadius: '0.5rem',
        fontWeight: 600,
        cursor: disabled || working ? 'not-allowed' : 'pointer',
        opacity: disabled || working ? 0.6 : 1,
        transition: 'all 0.25s',
        width: fluid ? '100%' : 'auto',
        justifyContent: 'center',
        fontFamily: 'system-ui, sans-serif',
        ...sizes[size],
        ...presets[preset],
        ...style
      }}
      disabled={disabled || working}
      {...props}
    >
      {working ? '◌' : before}
      {!working && children}
      {!working && after}
    </button>
  );
};
