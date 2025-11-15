import React from 'react';

export interface ButtonTheme {
  brandColor: string;
  neutralColor: string;
  errorColor: string;
  successColor: string;
  warningColor: string;
  surfaceColor: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  tone?: 'brand' | 'neutral' | 'error' | 'success' | 'warning';
  format?: 'filled' | 'bordered' | 'subtle' | 'plain';
  measure?: 'petite' | 'regular' | 'grande';
  theme?: Partial<ButtonTheme>;
  iconStart?: React.ReactNode;
  iconEnd?: React.ReactNode;
  busy?: boolean;
  wide?: boolean;
}

const defaultTheme: ButtonTheme = {
  brandColor: '#8b5cf6',
  neutralColor: '#64748b',
  errorColor: '#dc2626',
  successColor: '#059669',
  warningColor: '#d97706',
  surfaceColor: '#f8fafc'
};

export const Button: React.FC<ButtonProps> = ({
  tone = 'brand',
  format = 'filled',
  measure = 'regular',
  theme = {},
  iconStart,
  iconEnd,
  busy = false,
  wide = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const toneColor = appliedTheme[`${tone}Color`];

  const measureConfig = {
    petite: { padding: '0.5rem 1rem', fontSize: '0.875rem', minHeight: '2rem' },
    regular: { padding: '0.625rem 1.25rem', fontSize: '1rem', minHeight: '2.5rem' },
    grande: { padding: '0.875rem 1.75rem', fontSize: '1.125rem', minHeight: '3rem' }
  };

  const formatConfig = {
    filled: {
      backgroundColor: disabled ? appliedTheme.neutralColor : toneColor,
      color: '#ffffff',
      border: 'none'
    },
    bordered: {
      backgroundColor: appliedTheme.surfaceColor,
      color: disabled ? appliedTheme.neutralColor : toneColor,
      border: `2px solid ${disabled ? appliedTheme.neutralColor : toneColor}`
    },
    subtle: {
      backgroundColor: disabled ? `${appliedTheme.neutralColor}15` : `${toneColor}15`,
      color: disabled ? appliedTheme.neutralColor : toneColor,
      border: 'none'
    },
    plain: {
      backgroundColor: 'transparent',
      color: disabled ? appliedTheme.neutralColor : toneColor,
      border: 'none'
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: '0.625rem',
    fontWeight: 600,
    cursor: disabled || busy ? 'not-allowed' : 'pointer',
    opacity: busy ? 0.7 : 1,
    transition: 'all 0.2s ease',
    width: wide ? '100%' : 'auto',
    ...measureConfig[measure],
    ...formatConfig[format],
    ...style
  };

  return (
    <button disabled={disabled || busy} style={baseStyles} {...props}>
      {busy ? '⏳' : iconStart && <span style={{ display: 'flex' }}>{iconStart}</span>}
      <span>{children}</span>
      {!busy && iconEnd && <span style={{ display: 'flex' }}>{iconEnd}</span>}
    </button>
  );
};
