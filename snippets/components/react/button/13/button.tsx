import React, { useState } from 'react';

export interface ButtonTheme {
  primary: string;
  secondary: string;
  success: string;
  danger: string;
  warning: string;
  info: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'solid' | 'outline' | 'minimal' | 'elevated' | 'neumorphic';
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  fullWidth?: boolean;
  loading?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  disabled?: boolean;
  glass?: boolean;
  theme?: Partial<ButtonTheme>;
}

const defaultTheme: ButtonTheme = {
  primary: 'hsl(169, 70%, 50%)',
  secondary: 'hsl(199, 70%, 60%)',
  success: '#10b981',
  danger: '#ef4444',
  warning: '#f59e0b',
  info: '#06b6d4'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'solid',
  size = 'md',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  disabled = false,
  glass = false,
  theme = {},
  style,
  ...props
}) => {
  const [hovered, setHovered] = useState(false);
  const [active, setActive] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeStyles: Record<string, React.CSSProperties> = {
    xs: { padding: '0.375rem 0.75rem', fontSize: '0.75rem', gap: '0.25rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem', gap: '0.375rem' },
    md: { padding: '0.625rem 1.25rem', fontSize: '1rem', gap: '0.5rem' },
    lg: { padding: '0.75rem 1.5rem', fontSize: '1.125rem', gap: '0.625rem' },
    xl: { padding: '1rem 2rem', fontSize: '1.25rem', gap: '0.75rem' }
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    solid: {
      background: appliedTheme.primary,
      color: '#ffffff',
      border: 'none',
      boxShadow: `0 4px 6px ${appliedTheme.primary}30`,
      transform: hovered ? 'translateY(-2px)' : 'translateY(0)'
    },
    outline: {
      background: 'transparent',
      color: appliedTheme.primary,
      border: `2px solid ${appliedTheme.primary}`,
      boxShadow: hovered ? `0 0 0 3px ${appliedTheme.primary}20` : 'none'
    },
    ghost: {
      background: hovered ? `${appliedTheme.primary}15` : 'transparent',
      color: appliedTheme.primary,
      border: 'none',
      boxShadow: 'none'
    },
    gradient: {
      background: `linear-gradient(135deg, ${appliedTheme.primary}, ${appliedTheme.secondary})`,
      color: '#ffffff',
      border: 'none',
      boxShadow: `0 4px 15px ${appliedTheme.primary}50`
    },
    glass: {
      background: 'rgba(255, 255, 255, 0.1)',
      backdropFilter: 'blur(10px)',
      color: appliedTheme.primary,
      border: `1px solid ${appliedTheme.primary}40`,
      boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)'
    },
    soft: {
      background: `${appliedTheme.primary}20`,
      color: appliedTheme.primary,
      border: 'none',
      boxShadow: 'none'
    },
    neon: {
      background: '#000000',
      color: appliedTheme.primary,
      border: `2px solid ${appliedTheme.primary}`,
      boxShadow: hovered ? `0 0 20px ${appliedTheme.primary}, 0 0 40px ${appliedTheme.primary}80` : `0 0 10px ${appliedTheme.primary}`
    },
    neumorphic: {
      background: '#e0e5ec',
      color: '#4a5568',
      border: 'none',
      boxShadow: active ? 'inset 5px 5px 10px #a3b1c6, inset -5px -5px 10px #ffffff' : '5px 5px 10px #a3b1c6, -5px -5px 10px #ffffff'
    },
    raised: {
      background: appliedTheme.primary,
      color: '#ffffff',
      border: 'none',
      boxShadow: `0 6px 0 ${appliedTheme.secondary}, 0 8px 15px rgba(0, 0, 0, 0.2)`,
      transform: active ? 'translateY(4px)' : 'translateY(0)'
    },
    pulse: {
      background: appliedTheme.primary,
      color: '#ffffff',
      border: 'none',
      boxShadow: hovered ? `0 0 0 8px ${appliedTheme.primary}30` : 'none',
      animation: hovered ? 'pulse 1.5s infinite' : 'none'
    },
    shimmer: {
      background: `linear-gradient(135deg, ${appliedTheme.primary}, ${appliedTheme.secondary}, ${appliedTheme.primary})`,
      backgroundSize: '200% 100%',
      color: '#ffffff',
      border: 'none',
      animation: hovered ? 'shimmer 2s infinite' : 'none'
    },
    glow: {
      background: appliedTheme.primary,
      color: '#ffffff',
      border: 'none',
      boxShadow: hovered ? `0 0 20px ${appliedTheme.primary}, 0 0 40px ${appliedTheme.primary}80` : `0 4px 6px ${appliedTheme.primary}30`
    },
    'border-glow': {
      background: 'transparent',
      color: appliedTheme.primary,
      border: `2px solid ${appliedTheme.primary}`,
      boxShadow: hovered ? `0 0 15px ${appliedTheme.primary}, inset 0 0 15px ${appliedTheme.primary}40` : 'none'
    },
    minimal: {
      background: 'transparent',
      color: appliedTheme.primary,
      border: 'none',
      boxShadow: 'none',
      textDecoration: hovered ? 'underline' : 'none'
    },
    elevated: {
      background: appliedTheme.primary,
      color: '#ffffff',
      border: 'none',
      boxShadow: '0 8px 16px rgba(0, 0, 0, 0.2)',
      transform: hovered ? 'translateY(-2px) scale(1.02)' : 'translateY(0)'
    }
  };

  const baseStyles: React.CSSProperties = {
    position: 'relative',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: variant === 'neumorphic' ? '1rem' : '0.5rem',
    fontFamily: 'system-ui, -apple-system, sans-serif',
    fontWeight: 600,
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled ? 0.5 : 1,
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    width: fullWidth ? '100%' : 'auto',
    overflow: 'hidden',
    ...sizeStyles[size],
    ...variantStyles[variant],
    ...style
  };

  const spinnerStyle: React.CSSProperties = {
    width: '1em',
    height: '1em',
    border: '2px solid rgba(255, 255, 255, 0.3)',
    borderTopColor: '#ffffff',
    borderRadius: '50%',
    animation: 'ripple13 0.6s linear infinite'
  };

  return (
    <>
      <style>{`
        @keyframes ripple13 {
          to { transform: rotate(360deg); }
        }
        @keyframes pulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.5; }
        }
        @keyframes shimmer {
          0% { background-position: 200% 0; }
          100% { background-position: -200% 0; }
        }
      `}</style>
      <button
        style={baseStyles}
        disabled={disabled || loading}
        onMouseEnter={() => setHovered(true)}
        onMouseLeave={() => { setHovered(false); setActive(false); }}
        onMouseDown={() => setActive(true)}
        onMouseUp={() => setActive(false)}
        {...props}
      >
        {loading && <span style={spinnerStyle} />}
        {!loading && icon && iconPosition === 'left' && <span style={{ display: 'flex' }}>{icon}</span>}
        {!loading && <span>{children}</span>}
        {!loading && icon && iconPosition === 'right' && <span style={{ display: 'flex' }}>{icon}</span>}
      </button>
    </>
  );
};
