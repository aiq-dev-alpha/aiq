import React, { CSSProperties, ReactNode, useState } from 'react';

interface ButtonTheme {
  primary: string;
  secondary: string;
  success: string;
  danger: string;
  warning: string;
  info: string;
  neutral: string;
}

export type ButtonVariant = 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info';
export type ButtonSize = 'sm' | 'md' | 'lg';
export type ButtonStyle = 'outlined' | 'gradient' | 'soft';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  btnStyle?: ButtonStyle;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: ReactNode;
  iconPosition?: 'left' | 'right';
  theme?: Partial<ButtonTheme>;
  pulse?: boolean;
}

const defaultTheme: ButtonTheme = {
  primary: '#6366f1',
  secondary: '#64748b',
  success: '#10b981',
  danger: '#ef4444',
  warning: '#f59e0b',
  info: '#06b6d4',
  neutral: '#ffffff'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  btnStyle = 'outlined',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  className = '',
  disabled,
  theme = {},
  pulse = false,
  ...props
}) => {
  const [isHovered, setIsHovered] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };
  const color = appliedTheme[variant];

  const sizeStyles: Record<ButtonSize, CSSProperties> = {
    sm: { padding: '9px 18px', fontSize: '13px', minHeight: '36px', gap: '6px' },
    md: { padding: '13px 26px', fontSize: '15px', minHeight: '44px', gap: '8px' },
    lg: { padding: '17px 34px', fontSize: '17px', minHeight: '52px', gap: '10px' }
  };

  const styleMap: Record<ButtonStyle, CSSProperties> = {
    outlined: {
      background: isHovered ? `${color}10` : 'transparent',
      color: color,
      border: `2px solid ${color}`,
      boxShadow: isHovered ? `0 4px 12px ${color}30` : 'none'
    },
    gradient: {
      background: `linear-gradient(135deg, ${color}, ${color}cc)`,
      color: '#fff',
      border: 'none',
      boxShadow: `0 6px 20px ${color}40`
    },
    soft: {
      background: `${color}15`,
      color: color,
      border: `1px solid ${color}20`,
      boxShadow: isHovered ? `0 4px 10px ${color}20` : 'none'
    }
  };

  const baseStyles: CSSProperties = {
    ...sizeStyles[size],
    ...styleMap[btnStyle],
    width: fullWidth ? '100%' : 'auto',
    borderRadius: '11px',
    fontWeight: 700,
    letterSpacing: '0.4px',
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontFamily: 'inherit',
    outline: 'none',
    position: 'relative',
    opacity: disabled || loading ? 0.6 : 1,
    transform: isHovered && !disabled && !loading ? 'translateY(-2px)' : 'none'
  };

  const spinnerStyle: CSSProperties = {
    width: '17px',
    height: '17px',
    border: '2.5px solid currentColor',
    borderTopColor: 'transparent',
    borderRadius: '50%',
    animation: 'spin 0.75s linear infinite'
  };

  const pulseStyle: CSSProperties = pulse ? {
    animation: 'pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite'
  } : {};

  return (
    <>
      <style>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.8; }
        }
      `}</style>
      <button
        className={`btn-outlined ${className}`}
        style={{ ...baseStyles, ...pulseStyle }}
        disabled={disabled || loading}
        onMouseEnter={() => setIsHovered(true)}
        onMouseLeave={() => setIsHovered(false)}
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
