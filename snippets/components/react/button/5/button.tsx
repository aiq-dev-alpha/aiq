import React from 'react';

export type ButtonVariant = 'solid' | 'outline' | 'soft' | 'gradient' | 'neon';
export type ButtonSize = 'tiny' | 'small' | 'medium' | 'large' | 'huge';

interface StyleConfig {
  colors: {
    primary: string;
    secondary: string;
    accent: string;
  };
  spacing: {
    sm: string;
    md: string;
    lg: string;
  };
  radius: string;
  shadow: string;
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  block?: boolean;
  loading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  styleConfig?: Partial<StyleConfig>;
  customStyles?: React.CSSProperties;
}

const defaultConfig: StyleConfig = {
  colors: {
    primary: '#6366f1',
    secondary: '#8b5cf6',
    accent: '#ec4899'
  },
  spacing: {
    sm: '0.5rem',
    md: '1rem',
    lg: '1.5rem'
  },
  radius: '0.75rem',
  shadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'solid',
  size = 'medium',
  block = false,
  loading = false,
  leftIcon,
  rightIcon,
  styleConfig = {},
  customStyles = {},
  disabled,
  ...props
}) => {
  const config = { ...defaultConfig, ...styleConfig };

  const getSizeStyles = (): React.CSSProperties => {
    const sizes = {
      tiny: { padding: '0.25rem 0.5rem', fontSize: '0.75rem', minHeight: '1.5rem' },
      small: { padding: '0.5rem 1rem', fontSize: '0.875rem', minHeight: '2rem' },
      medium: { padding: '0.75rem 1.5rem', fontSize: '1rem', minHeight: '2.5rem' },
      large: { padding: '1rem 2rem', fontSize: '1.125rem', minHeight: '3rem' },
      huge: { padding: '1.25rem 2.5rem', fontSize: '1.25rem', minHeight: '3.5rem' }
    };
    return sizes[size];
  };

  const getVariantStyles = (): React.CSSProperties => {
    const variants = {
      solid: {
        background: config.colors.primary,
        color: '#fff',
        border: 'none',
        boxShadow: config.shadow
      },
      outline: {
        background: 'transparent',
        color: config.colors.primary,
        border: `2px solid ${config.colors.primary}`,
        boxShadow: 'none'
      },
      soft: {
        background: `${config.colors.primary}20`,
        color: config.colors.primary,
        border: 'none',
        boxShadow: 'none'
      },
      gradient: {
        background: `linear-gradient(135deg, ${config.colors.primary}, ${config.colors.secondary})`,
        color: '#fff',
        border: 'none',
        boxShadow: config.shadow
      },
      neon: {
        background: 'transparent',
        color: config.colors.accent,
        border: `2px solid ${config.colors.accent}`,
        boxShadow: `0 0 10px ${config.colors.accent}50`
      }
    };
    return variants[variant];
  };

  const buttonStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: config.radius,
    fontWeight: 600,
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled || loading ? 0.5 : 1,
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    width: block ? '100%' : 'auto',
    ...getSizeStyles(),
    ...getVariantStyles(),
    ...customStyles
  };

  return (
    <button style={buttonStyles} disabled={disabled || loading} {...props}>
      {loading ? (
        <span style={{ display: 'inline-block', animation: 'rotate 1s linear infinite' }}>⚡</span>
      ) : (
        <>
          {leftIcon && <span>{leftIcon}</span>}
          <span>{children}</span>
          {rightIcon && <span>{rightIcon}</span>}
        </>
      )}
    </button>
  );
};
