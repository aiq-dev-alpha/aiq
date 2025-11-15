import React, { CSSProperties, ReactNode, useState } from 'react';

interface ButtonTheme {
  primary: string;
  secondary: string;
  success: string;
  danger: string;
  warning: string;
  info: string;
  glass: string;
}

export type ButtonVariant = 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info';
export type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: ReactNode;
  iconPosition?: 'left' | 'right';
  theme?: Partial<ButtonTheme>;
  glass?: boolean;
}

const defaultTheme: ButtonTheme = {
  primary: '#3b82f6',
  secondary: '#64748b',
  success: '#10b981',
  danger: '#ef4444',
  warning: '#f59e0b',
  info: '#06b6d4',
  glass: 'rgba(255, 255, 255, 0.1)'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  className = '',
  disabled,
  theme = {},
  glass = true,
  ...props
}) => {
  const [ripples, setRipples] = useState<Array<{x: number; y: number; id: number}>>([]);
  const appliedTheme = { ...defaultTheme, ...theme };
  const color = appliedTheme[variant];

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const id = Date.now();
    setRipples(prev => [...prev, { x, y, id }]);
    setTimeout(() => {
      setRipples(prev => prev.filter(r => r.id !== id));
    }, 600);
    props.onClick?.(e);
  };

  const sizeStyles: Record<ButtonSize, CSSProperties> = {
    sm: { padding: '9px 20px', fontSize: '13px', minHeight: '36px', gap: '7px' },
    md: { padding: '13px 28px', fontSize: '15px', minHeight: '44px', gap: '9px' },
    lg: { padding: '17px 36px', fontSize: '17px', minHeight: '52px', gap: '11px' }
  };

  const baseStyles: CSSProperties = {
    ...sizeStyles[size],
    width: fullWidth ? '100%' : 'auto',
    borderRadius: '14px',
    fontWeight: 700,
    letterSpacing: '0.4px',
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    transition: 'all 0.35s cubic-bezier(0.4, 0, 0.2, 1)',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontFamily: 'inherit',
    outline: 'none',
    position: 'relative',
    overflow: 'hidden',
    border: glass ? `1px solid ${color}40` : 'none',
    background: glass
      ? `${color}20`
      : `linear-gradient(135deg, ${color}, ${color}dd)`,
    color: glass ? color : '#fff',
    boxShadow: glass
      ? `0 4px 20px ${color}25, inset 0 1px 0 rgba(255,255,255,0.1)`
      : `0 6px 24px ${color}40`,
    backdropFilter: glass ? 'blur(12px)' : 'none',
    opacity: disabled || loading ? 0.6 : 1
  };

  const spinnerStyle: CSSProperties = {
    width: '18px',
    height: '18px',
    border: `2.5px solid ${glass ? color : '#fff'}`,
    borderTopColor: 'transparent',
    borderRadius: '50%',
    animation: 'spin 0.8s linear infinite'
  };

  const rippleStyles: CSSProperties = {
    position: 'absolute',
    borderRadius: '50%',
    background: 'rgba(255, 255, 255, 0.5)',
    transform: 'scale(0)',
    animation: 'ripple 0.6s ease-out',
    pointerEvents: 'none'
  };

  return (
    <>
      <style>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
        @keyframes ripple {
          to {
            transform: scale(4);
            opacity: 0;
          }
        }
        .btn-glass:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 8px 32px ${color}35, inset 0 1px 0 rgba(255,255,255,0.15);
        }
        .btn-glass:active:not(:disabled) {
          transform: translateY(0) scale(0.98);
        }
      `}</style>
      <button
        className={`btn-glass ${className}`}
        style={baseStyles}
        disabled={disabled || loading}
        onClick={handleClick}
        {...props}
      >
        {ripples.map(ripple => (
          <span
            key={ripple.id}
            style={{
              ...rippleStyles,
              left: ripple.x,
              top: ripple.y,
              width: '20px',
              height: '20px',
              marginLeft: '-10px',
              marginTop: '-10px'
            }}
          />
        ))}
        {loading && <span style={spinnerStyle} />}
        {!loading && icon && iconPosition === 'left' && <span>{icon}</span>}
        {!loading && <span>{children}</span>}
        {!loading && icon && iconPosition === 'right' && <span>{icon}</span>}
      </button>
    </>
  );
};
