import React from 'react';

export interface ButtonTheme {
  primary: { base: string; hover: string; active: string };
  secondary: { base: string; hover: string; active: string };
  radius: string;
  transition: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  tier?: 'primary' | 'secondary';
  state?: 'default' | 'hover' | 'active' | 'disabled';
  sizeVariant?: 'mini' | 'small' | 'base' | 'large' | 'jumbo';
  theme?: Partial<ButtonTheme>;
  prefixContent?: React.ReactNode;
  suffixContent?: React.ReactNode;
  fillContainer?: boolean;
}

const defaultTheme: ButtonTheme = {
  primary: { base: '#f59e0b', hover: '#d97706', active: '#b45309' },
  secondary: { base: '#6366f1', hover: '#4f46e5', active: '#4338ca' },
  radius: '0.5rem',
  transition: 'all 0.2s ease'
};

export const Button: React.FC<ButtonProps> = ({
  tier = 'primary',
  state = 'default',
  sizeVariant = 'base',
  theme = {},
  prefixContent,
  suffixContent,
  fillContainer = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const [currentState, setCurrentState] = React.useState(state);

  const sizeVariantConfig = {
    mini: { padding: '0.25rem 0.625rem', fontSize: '0.75rem', height: '1.75rem' },
    small: { padding: '0.375rem 0.875rem', fontSize: '0.875rem', height: '2.25rem' },
    base: { padding: '0.5rem 1.125rem', fontSize: '1rem', height: '2.75rem' },
    large: { padding: '0.625rem 1.375rem', fontSize: '1.125rem', height: '3.25rem' },
    jumbo: { padding: '0.875rem 1.75rem', fontSize: '1.25rem', height: '4rem' }
  };

  const getBackgroundColor = () => {
    if (disabled) return '#9ca3af';
    const colors = appliedTheme[tier];
    switch (currentState) {
      case 'hover': return colors.hover;
      case 'active': return colors.active;
      default: return colors.base;
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    backgroundColor: getBackgroundColor(),
    color: '#ffffff',
    border: 'none',
    borderRadius: appliedTheme.radius,
    fontWeight: 600,
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: appliedTheme.transition,
    width: fillContainer ? '100%' : 'auto',
    ...sizeVariantConfig[sizeVariant],
    ...style
  };

  return (
    <button
      disabled={disabled}
      onMouseEnter={() => !disabled && setCurrentState('hover')}
      onMouseLeave={() => !disabled && setCurrentState('default')}
      onMouseDown={() => !disabled && setCurrentState('active')}
      onMouseUp={() => !disabled && setCurrentState('hover')}
      style={baseStyles}
      {...props}
    >
      {prefixContent && <span style={{ display: 'flex' }}>{prefixContent}</span>}
      {children}
      {suffixContent && <span style={{ display: 'flex' }}>{suffixContent}</span>}
    </button>
  );
};
