import React from 'react';

export interface ButtonTheme {
  mainColor: string;
  accentColor: string;
  neutralColor: string;
  spacing: { x: number; y: number };
  roundness: number;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  priority?: 'high' | 'medium' | 'low' | 'none';
  form?: 'rectangle' | 'rounded' | 'pill' | 'square';
  scale?: 'tiny' | 'small' | 'regular' | 'large' | 'huge';
  theme?: Partial<ButtonTheme>;
  iconBefore?: React.ReactNode;
  iconAfter?: React.ReactNode;
  isLoading?: boolean;
  isFullWidth?: boolean;
}

const defaultTheme: ButtonTheme = {
  mainColor: '#4f46e5',
  accentColor: '#818cf8',
  neutralColor: '#94a3b8',
  spacing: { x: 16, y: 8 },
  roundness: 8
};

export const Button: React.FC<ButtonProps> = ({
  priority = 'high',
  form = 'rounded',
  scale = 'regular',
  theme = {},
  iconBefore,
  iconAfter,
  isLoading = false,
  isFullWidth = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const priorityMap = {
    high: {
      backgroundColor: appliedTheme.mainColor,
      color: '#ffffff',
      border: 'none',
      fontWeight: 700
    },
    medium: {
      backgroundColor: appliedTheme.accentColor,
      color: '#ffffff',
      border: 'none',
      fontWeight: 600
    },
    low: {
      backgroundColor: 'transparent',
      color: appliedTheme.mainColor,
      border: `2px solid ${appliedTheme.mainColor}`,
      fontWeight: 500
    },
    none: {
      backgroundColor: 'transparent',
      color: appliedTheme.neutralColor,
      border: 'none',
      fontWeight: 400
    }
  };

  const formMap = {
    rectangle: '0',
    rounded: `${appliedTheme.roundness}px`,
    pill: '9999px',
    square: '0'
  };

  const scaleMap = {
    tiny: { padding: `${appliedTheme.spacing.y / 2}px ${appliedTheme.spacing.x / 2}px`, fontSize: '0.75rem' },
    small: { padding: `${appliedTheme.spacing.y}px ${appliedTheme.spacing.x}px`, fontSize: '0.875rem' },
    regular: { padding: `${appliedTheme.spacing.y * 1.5}px ${appliedTheme.spacing.x * 1.5}px`, fontSize: '1rem' },
    large: { padding: `${appliedTheme.spacing.y * 2}px ${appliedTheme.spacing.x * 2}px`, fontSize: '1.125rem' },
    huge: { padding: `${appliedTheme.spacing.y * 2.5}px ${appliedTheme.spacing.x * 2.5}px`, fontSize: '1.25rem' }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    borderRadius: formMap[form],
    cursor: isLoading ? 'wait' : 'pointer',
    opacity: isLoading ? 0.7 : 1,
    transition: 'all 0.2s ease',
    width: isFullWidth ? '100%' : form === 'square' ? scaleMap[scale].padding : 'auto',
    height: form === 'square' ? scaleMap[scale].padding : 'auto',
    ...scaleMap[scale],
    ...priorityMap[priority],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {isLoading ? (
        <span>⏳</span>
      ) : (
        <>
          {iconBefore && <span style={{ display: 'flex' }}>{iconBefore}</span>}
          {form !== 'square' && <span>{children}</span>}
          {form === 'square' && (iconBefore || children)}
          {iconAfter && <span style={{ display: 'flex' }}>{iconAfter}</span>}
        </>
      )}
    </button>
  );
};
