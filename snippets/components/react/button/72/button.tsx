import React from 'react';

export interface ButtonTheme {
  primaryColor: string;
  secondaryColor: string;
  textColor: string;
  borderRadius: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'tertiary';
  size?: 'sm' | 'md' | 'lg';
  theme?: Partial<ButtonTheme>;
  icon?: React.ReactNode;
  fullWidth?: boolean;
}

const defaultTheme: ButtonTheme = {
  primaryColor: '#${i}${i}${i}${i}',
  secondaryColor: '#${i}${i}${i}${i}',
  textColor: '#ffffff',
  borderRadius: '0.5rem'
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  theme = {},
  icon,
  fullWidth = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const sizeMap = {
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    md: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
    lg: { padding: '1rem 2rem', fontSize: '1.125rem' }
  };

  const variantMap = {
    primary: { backgroundColor: appliedTheme.primaryColor, color: appliedTheme.textColor },
    secondary: { backgroundColor: appliedTheme.secondaryColor, color: appliedTheme.textColor },
    tertiary: { backgroundColor: 'transparent', color: appliedTheme.primaryColor, border: `2px solid ${appliedTheme.primaryColor}` }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    border: 'none',
    borderRadius: appliedTheme.borderRadius,
    fontWeight: 600,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: fullWidth ? '100%' : 'auto',
    ...sizeMap[size],
    ...variantMap[variant],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {icon && <span style={{ display: 'flex' }}>{icon}</span>}
      <span>{children}</span>
    </button>
  );
};
