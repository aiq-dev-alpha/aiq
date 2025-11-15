import React, { CSSProperties, ButtonHTMLAttributes } from 'react';

interface ColorSet {
  main: string;
  light: string;
  dark: string;
  text: string;
}

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  colors?: Partial<ColorSet>;
  visual?: 'solid' | 'subtle' | 'outline' | 'ghost' | 'link';
  scale?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  loading?: boolean;
  icon?: React.ReactNode;
  iconAlign?: 'left' | 'right';
  fluid?: boolean;
  pill?: boolean;
}

const baseColors: ColorSet = {
  main: '#6366f1',
  light: '#818cf8',
  dark: '#4f46e5',
  text: '#ffffff'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  colors = {},
  visual = 'solid',
  scale = 'md',
  loading = false,
  icon,
  iconAlign = 'left',
  fluid = false,
  pill = false,
  disabled,
  ...props
}) => {
  const c = { ...baseColors, ...colors };
  const scales: Record<string, CSSProperties> = {
    xs: { padding: '5px 10px', fontSize: '12px' },
    sm: { padding: '7px 14px', fontSize: '13px' },
    md: { padding: '10px 20px', fontSize: '14px' },
    lg: { padding: '12px 24px', fontSize: '16px' },
    xl: { padding: '14px 28px', fontSize: '18px' }
  };

  const visuals: Record<string, CSSProperties> = {
    solid: { background: c.main, color: c.text, border: 'none', boxShadow: `0 2px 8px ${c.main}40` },
    subtle: { background: `${c.main}18`, color: c.dark, border: 'none', boxShadow: 'none' },
    outline: { background: 'transparent', color: c.main, border: `2px solid ${c.main}`, boxShadow: 'none' },
    ghost: { background: 'transparent', color: c.main, border: 'none', boxShadow: 'none' },
    link: { background: 'transparent', color: c.main, border: 'none', boxShadow: 'none', textDecoration: 'underline' }
  };

  const style: CSSProperties = {
    ...scales[scale],
    ...visuals[visual],
    borderRadius: pill ? '999px' : '9px',
    width: fluid ? '100%' : 'auto',
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled || loading ? 0.6 : 1,
    transition: 'all 0.2s ease',
    fontWeight: 600,
    fontFamily: 'inherit',
    outline: 'none',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px'
  };

  return (
    <button
      style={style}
      disabled={disabled || loading}
      onMouseEnter={(e) => !disabled && !loading && (e.currentTarget.style.filter = 'brightness(1.1)')}
      onMouseLeave={(e) => (e.currentTarget.style.filter = 'none')}
      {...props}>
      {loading ? (
        <span style={{ width: '14px', height: '14px', border: '2px solid currentColor', borderTopColor: 'transparent', borderRadius: '50%', animation: 'spin 0.6s linear infinite' }} />
      ) : (
        <>
          {icon && iconAlign === 'left' && icon}
          {children}
          {icon && iconAlign === 'right' && icon}
        </>
      )}
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </button>
  );
};
