import React from 'react';

export type ButtonMode = 'flat' | 'raised' | 'stroked' | 'fab' | 'icon';
export type ButtonDimension = 'compact' | 'cozy' | 'relaxed' | 'spacious';

interface DesignTokens {
  colors: {
    primary: string;
    onPrimary: string;
    surface: string;
    outline: string;
  };
  shapes: {
    cornerRadius: string;
    elevation: string;
  };
  motion: {
    duration: string;
    easing: string;
  };
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  mode?: ButtonMode;
  dimension?: ButtonDimension;
  fluid?: boolean;
  processing?: boolean;
  leadingIcon?: React.ReactNode;
  trailingIcon?: React.ReactNode;
  tokens?: Partial<DesignTokens>;
  overrides?: React.CSSProperties;
}

const defaultTokens: DesignTokens = {
  colors: {
    primary: '#7c3aed',
    onPrimary: '#ffffff',
    surface: '#fafafa',
    outline: '#e4e4e7'
  },
  shapes: {
    cornerRadius: '0.5rem',
    elevation: '0 2px 8px rgba(0, 0, 0, 0.12)'
  },
  motion: {
    duration: '200ms',
    easing: 'cubic-bezier(0.4, 0, 0.2, 1)'
  }
};

export const Button: React.FC<ButtonProps> = ({
  children,
  mode = 'flat',
  dimension = 'cozy',
  fluid = false,
  processing = false,
  leadingIcon,
  trailingIcon,
  tokens = {},
  overrides = {},
  disabled,
  ...props
}) => {
  const designTokens = { ...defaultTokens, ...tokens };

  const dimensionStyles: Record<ButtonDimension, React.CSSProperties> = {
    compact: { padding: '0.375rem 0.875rem', fontSize: '0.813rem', minHeight: '2rem' },
    cozy: { padding: '0.625rem 1.25rem', fontSize: '0.938rem', minHeight: '2.5rem' },
    relaxed: { padding: '0.875rem 1.75rem', fontSize: '1rem', minHeight: '3rem' },
    spacious: { padding: '1.125rem 2.25rem', fontSize: '1.063rem', minHeight: '3.5rem' }
  };

  const modeStyles: Record<ButtonMode, React.CSSProperties> = {
    flat: {
      backgroundColor: designTokens.colors.primary,
      color: designTokens.colors.onPrimary,
      border: 'none',
      boxShadow: 'none'
    },
    raised: {
      backgroundColor: designTokens.colors.primary,
      color: designTokens.colors.onPrimary,
      border: 'none',
      boxShadow: designTokens.shapes.elevation
    },
    stroked: {
      backgroundColor: 'transparent',
      color: designTokens.colors.primary,
      border: `1.5px solid ${designTokens.colors.outline}`,
      boxShadow: 'none'
    },
    fab: {
      backgroundColor: designTokens.colors.primary,
      color: designTokens.colors.onPrimary,
      border: 'none',
      boxShadow: designTokens.shapes.elevation,
      borderRadius: '50%',
      padding: '1rem',
      minWidth: '3.5rem',
      minHeight: '3.5rem'
    },
    icon: {
      backgroundColor: 'transparent',
      color: designTokens.colors.primary,
      border: 'none',
      boxShadow: 'none',
      padding: '0.5rem',
      borderRadius: '50%'
    }
  };

  const computedStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: mode === 'fab' || mode === 'icon' ? '50%' : designTokens.shapes.cornerRadius,
    fontWeight: 500,
    cursor: disabled || processing ? 'not-allowed' : 'pointer',
    opacity: disabled || processing ? 0.6 : 1,
    transition: `all ${designTokens.motion.duration} ${designTokens.motion.easing}`,
    width: fluid ? '100%' : 'auto',
    ...dimensionStyles[dimension],
    ...modeStyles[mode],
    ...overrides
  };

  return (
    <button style={computedStyles} disabled={disabled || processing} {...props}>
      {processing ? (
        <span>⌛</span>
      ) : (
        <>
          {leadingIcon && <span>{leadingIcon}</span>}
          {children && <span>{children}</span>}
          {trailingIcon && <span>{trailingIcon}</span>}
        </>
      )}
    </button>
  );
};
