import React, { CSSProperties, ReactNode } from 'react';

interface ButtonTheme {
  primary: string;
  secondary: string;
  success: string;
  danger: string;
  warning: string;
  info: string;
  surface: string;
  onSurface: string;
}

export type ButtonVariant = 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info';
export type ButtonSize = 'sm' | 'md' | 'lg';
export type ButtonAppearance = 'solid' | 'outline' | 'ghost' | 'soft';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  appearance?: ButtonAppearance;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: ReactNode;
  iconPosition?: 'left' | 'right';
  theme?: Partial<ButtonTheme>;
}

const defaultTheme: ButtonTheme = {
  primary: '#3b82f6',
  secondary: '#64748b',
  success: '#22c55e',
  danger: '#ef4444',
  warning: '#f59e0b',
  info: '#06b6d4',
  surface: '#ffffff',
  onSurface: '#0f172a'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  appearance = 'solid',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  className = '',
  disabled,
  theme = {},
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const baseColor = appliedTheme[variant];

  const sizeStyles: Record<ButtonSize, CSSProperties> = {
    sm: { padding: '8px 16px', fontSize: '13px', minHeight: '34px', gap: '6px' },
    md: { padding: '12px 24px', fontSize: '15px', minHeight: '42px', gap: '8px' },
    lg: { padding: '16px 32px', fontSize: '17px', minHeight: '50px', gap: '10px' }
  };

  const appearanceStyles: Record<ButtonAppearance, CSSProperties> = {
    solid: {
      background: baseColor,
      color: '#fff',
      border: 'none',
      boxShadow: `0 4px 14px ${baseColor}40`
    },
    outline: {
      background: 'transparent',
      color: baseColor,
      border: `2px solid ${baseColor}`,
      boxShadow: 'none'
    },
    ghost: {
      background: 'transparent',
      color: baseColor,
      border: 'none',
      boxShadow: 'none'
    },
    soft: {
      background: `${baseColor}15`,
      color: baseColor,
      border: `1px solid ${baseColor}30`,
      boxShadow: '0 1px 3px rgba(0, 0, 0, 0.05)'
    }
  };

  const baseStyles: CSSProperties = {
    ...sizeStyles[size],
    ...appearanceStyles[appearance],
    width: fullWidth ? '100%' : 'auto',
    borderRadius: '10px',
    fontWeight: 600,
    letterSpacing: '0.3px',
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontFamily: 'inherit',
    outline: 'none',
    position: 'relative',
    opacity: disabled || loading ? 0.6 : 1
  };

  const spinnerStyle: CSSProperties = {
    width: '16px',
    height: '16px',
    border: '2px solid currentColor',
    borderTopColor: 'transparent',
    borderRadius: '50%',
    animation: 'spin 0.7s linear infinite'
  };

  return (
    <>
      <style>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
        .btn-modern:hover:not(:disabled) {
          transform: translateY(-2px);
          filter: brightness(1.1);
        }
        .btn-modern:active:not(:disabled) {
          transform: translateY(0) scale(0.98);
        }
      `}</style>
      <button
        className={`btn-modern ${className}`}
        style={baseStyles}
        disabled={disabled || loading}
        {...props}
      >
        {loading && <span style={spinnerStyle} />}
        {!loading && icon && iconPosition === 'left' && <span>{icon}</span>}
        {!loading && <span>{children}</span>}
        {!loading && icon && iconPosition === 'right' && <span>{icon}</span>}
      </button>
    </>
  );
};
