import React from 'react';

type Kind = 'solid' | 'soft' | 'outline' | 'ghost' | 'link';
type Sizing = 'tiny' | 'small' | 'medium' | 'large' | 'huge';

interface Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  kind?: Kind;
  sizing?: Sizing;
  block?: boolean;
  busy?: boolean;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
}

export const Button: React.FC<Props> = ({
  children,
  kind = 'solid',
  sizing = 'medium',
  block = false,
  busy = false,
  prefix,
  suffix,
  disabled,
  style,
  ...props
}) => {
  const color = '#8b5cf6';

  const kinds: Record<Kind, React.CSSProperties> = {
    solid: { background: color, color: '#fff', border: 'none' },
    soft: { background: `${color}20`, color: color, border: 'none' },
    outline: { background: 'transparent', color: color, border: `2px solid ${color}` },
    ghost: { background: 'transparent', color: color, border: 'none' },
    link: { background: 'transparent', color: color, border: 'none', textDecoration: 'underline' }
  };

  const sizings: Record<Sizing, React.CSSProperties> = {
    tiny: { padding: '0.25rem 0.5rem', fontSize: '0.75rem' },
    small: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    medium: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
    large: { padding: '1rem 2rem', fontSize: '1.125rem' },
    huge: { padding: '1.25rem 2.5rem', fontSize: '1.375rem' }
  };

  return (
    <button
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '0.5rem',
        borderRadius: '0.625rem',
        fontWeight: 600,
        cursor: disabled || busy ? 'not-allowed' : 'pointer',
        opacity: disabled || busy ? 0.5 : 1,
        transition: 'all 0.2s',
        width: block ? '100%' : 'auto',
        justifyContent: 'center',
        fontFamily: 'system-ui, sans-serif',
        ...sizings[sizing],
        ...kinds[kind],
        ...style
      }}
      disabled={disabled || busy}
      {...props}
    >
      {busy ? '⚙' : prefix}
      {!busy && children}
      {!busy && suffix}
    </button>
  );
};
