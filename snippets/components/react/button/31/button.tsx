import React from 'react';

export interface ButtonTheme {
  accentHue: number;
  neutralColor: string;
  radius: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  intent?: 'neutral' | 'positive' | 'negative' | 'warning';
  size?: 'tiny' | 'small' | 'medium' | 'large' | 'huge';
  theme?: Partial<ButtonTheme>;
  prefix?: React.ReactNode;
  suffix?: React.ReactNode;
  loading?: boolean;
  fluid?: boolean;
}

const defaultTheme: ButtonTheme = {
  accentHue: 220,
  neutralColor: '#64748b',
  radius: 8
};

export const Button: React.FC<ButtonProps> = ({
  intent = 'neutral',
  size = 'medium',
  theme = {},
  prefix,
  suffix,
  loading = false,
  fluid = false,
  children,
  disabled,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const intentColors = {
    neutral: appliedTheme.neutralColor,
    positive: `hsl(${appliedTheme.accentHue}, 70%, 50%)`,
    negative: 'hsl(0, 70%, 50%)',
    warning: 'hsl(45, 90%, 50%)'
  };

  const sizeConfig = {
    tiny: { padding: '0.25rem 0.5rem', fontSize: '0.75rem', gap: '0.25rem' },
    small: { padding: '0.375rem 0.75rem', fontSize: '0.875rem', gap: '0.375rem' },
    medium: { padding: '0.5rem 1rem', fontSize: '1rem', gap: '0.5rem' },
    large: { padding: '0.75rem 1.25rem', fontSize: '1.125rem', gap: '0.625rem' },
    huge: { padding: '1rem 1.75rem', fontSize: '1.25rem', gap: '0.75rem' }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: intentColors[intent],
    color: '#ffffff',
    border: 'none',
    borderRadius: `${appliedTheme.radius}px`,
    fontWeight: 500,
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled ? 0.5 : 1,
    transition: 'transform 0.1s ease, box-shadow 0.2s ease',
    width: fluid ? '100%' : 'auto',
    ...sizeConfig[size],
    ...style
  };

  return (
    <button
      disabled={disabled || loading}
      style={baseStyles}
      onMouseDown={(e) => (e.currentTarget.style.transform = 'scale(0.97)')}
      onMouseUp={(e) => (e.currentTarget.style.transform = 'scale(1)')}
      onMouseLeave={(e) => (e.currentTarget.style.transform = 'scale(1)')}
      {...props}
    >
      {loading ? '⏳' : prefix && <span>{prefix}</span>}
      <span>{children}</span>
      {!loading && suffix && <span>{suffix}</span>}
    </button>
  );
};
