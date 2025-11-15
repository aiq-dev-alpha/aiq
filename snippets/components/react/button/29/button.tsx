import React from 'react';

export interface ButtonTheme {
  baseColor: string;
  accentColor: string;
  backgroundColor: string;
  borderColor: string;
  spacing: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  appearance?: 'default' | 'primary' | 'subtle' | 'link';
  spacing?: 'compact' | 'default' | 'loose';
  theme?: Partial<ButtonTheme>;
  iconBefore?: React.ReactNode;
  iconAfter?: React.ReactNode;
  isSelected?: boolean;
  shouldFitContainer?: boolean;
}

const defaultTheme: ButtonTheme = {
  baseColor: '#1f2937',
  accentColor: '#3b82f6',
  backgroundColor: '#f3f4f6',
  borderColor: '#d1d5db',
  spacing: '0.5rem'
};

export const Button: React.FC<ButtonProps> = ({
  appearance = 'default',
  spacing = 'default',
  theme = {},
  iconBefore,
  iconAfter,
  isSelected = false,
  shouldFitContainer = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const spacingConfig = {
    compact: { padding: '0.25rem 0.75rem', gap: '0.25rem' },
    default: { padding: '0.5rem 1rem', gap: '0.5rem' },
    loose: { padding: '0.75rem 1.5rem', gap: '0.75rem' }
  };

  const appearanceConfig = {
    default: {
      backgroundColor: isSelected ? appliedTheme.backgroundColor : 'transparent',
      color: appliedTheme.baseColor,
      border: `1px solid ${appliedTheme.borderColor}`,
      ':hover': { backgroundColor: appliedTheme.backgroundColor }
    },
    primary: {
      backgroundColor: appliedTheme.accentColor,
      color: '#ffffff',
      border: 'none',
      ':hover': { filter: 'brightness(0.9)' }
    },
    subtle: {
      backgroundColor: isSelected ? `${appliedTheme.accentColor}15` : 'transparent',
      color: appliedTheme.accentColor,
      border: 'none',
      ':hover': { backgroundColor: `${appliedTheme.accentColor}20` }
    },
    link: {
      backgroundColor: 'transparent',
      color: appliedTheme.accentColor,
      border: 'none',
      textDecoration: 'underline',
      ':hover': { textDecoration: 'none' }
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: '0.375rem',
    fontSize: '0.875rem',
    fontWeight: 500,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: shouldFitContainer ? '100%' : 'auto',
    ...spacingConfig[spacing],
    ...appearanceConfig[appearance],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {iconBefore && <span style={{ display: 'flex' }}>{iconBefore}</span>}
      {children}
      {iconAfter && <span style={{ display: 'flex' }}>{iconAfter}</span>}
    </button>
  );
};
