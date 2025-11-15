import React from 'react';

export type ButtonVariant = 'contained' | 'outlined' | 'text' | 'gradient' | 'glass';
export type ButtonSize = 'mini' | 'small' | 'normal' | 'large' | 'jumbo';

interface StyleSchema {
  palette: {
    base: string;
    hover: string;
    active: string;
    disabled: string;
  };
  geometry: {
    radius: string;
    elevation: string;
  };
  typography: {
    family: string;
    weight: number;
  };
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  expand?: boolean;
  busy?: boolean;
  prefixIcon?: React.ReactNode;
  suffixIcon?: React.ReactNode;
  schema?: Partial<StyleSchema>;
  customStyle?: React.CSSProperties;
}

const defaultSchema: StyleSchema = {
  palette: {
    base: '#6366f1',
    hover: '#4f46e5',
    active: '#4338ca',
    disabled: '#9ca3af'
  },
  geometry: {
    radius: '0.625rem',
    elevation: '0 4px 12px rgba(0, 0, 0, 0.15)'
  },
  typography: {
    family: 'Inter, system-ui, sans-serif',
    weight: 600
  }
};

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'contained',
  size = 'normal',
  expand = false,
  busy = false,
  prefixIcon,
  suffixIcon,
  schema = {},
  customStyle = {},
  disabled,
  ...props
}) => {
  const config = { ...defaultSchema, ...schema };

  const getDimensionsBySize = (): React.CSSProperties => {
    const dimensions = {
      mini: { padding: '0.375rem 0.625rem', fontSize: '0.75rem', minHeight: '1.75rem' },
      small: { padding: '0.5rem 1rem', fontSize: '0.875rem', minHeight: '2.25rem' },
      normal: { padding: '0.75rem 1.5rem', fontSize: '1rem', minHeight: '2.75rem' },
      large: { padding: '1rem 2rem', fontSize: '1.125rem', minHeight: '3.25rem' },
      jumbo: { padding: '1.25rem 2.5rem', fontSize: '1.25rem', minHeight: '4rem' }
    };
    return dimensions[size];
  };

  const getVariantStyling = (): React.CSSProperties => {
    const styles = {
      contained: {
        background: config.palette.base,
        color: '#ffffff',
        border: 'none',
        boxShadow: config.geometry.elevation
      },
      outlined: {
        background: 'transparent',
        color: config.palette.base,
        border: `2px solid ${config.palette.base}`,
        boxShadow: 'none'
      },
      text: {
        background: 'transparent',
        color: config.palette.base,
        border: 'none',
        boxShadow: 'none'
      },
      gradient: {
        background: `linear-gradient(135deg, ${config.palette.base}, ${config.palette.hover})`,
        color: '#ffffff',
        border: 'none',
        boxShadow: config.geometry.elevation
      },
      glass: {
        background: `${config.palette.base}25`,
        color: config.palette.base,
        border: `1px solid ${config.palette.base}40`,
        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)',
        backdropFilter: 'blur(10px)'
      }
    };
    return styles[variant];
  };

  const composedStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.625rem',
    borderRadius: config.geometry.radius,
    fontFamily: config.typography.family,
    fontWeight: config.typography.weight,
    cursor: disabled || busy ? 'not-allowed' : 'pointer',
    opacity: disabled || busy ? 0.5 : 1,
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    width: expand ? '100%' : 'auto',
    ...getDimensionsBySize(),
    ...getVariantStyling(),
    ...customStyle
  };

  return (
    <button style={composedStyles} disabled={disabled || busy} {...props}>
      {busy ? (
        <span style={{ animation: 'spin 1s linear infinite' }}>⚙</span>
      ) : (
        <>
          {prefixIcon && <span>{prefixIcon}</span>}
          <span>{children}</span>
          {suffixIcon && <span>{suffixIcon}</span>}
        </>
      )}
    </button>
  );
};
