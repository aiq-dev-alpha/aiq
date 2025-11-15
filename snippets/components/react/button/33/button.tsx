import React from 'react';

export interface ButtonTheme {
  colorScheme: {
    background: string;
    foreground: string;
    accent: string;
    muted: string;
  };
  spacing: {
    unit: number;
  };
  typography: {
    scale: number;
  };
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  emphasis?: 'high' | 'medium' | 'low' | 'minimal';
  dimension?: 'compact' | 'standard' | 'comfortable' | 'spacious';
  theme?: Partial<ButtonTheme>;
  leftElement?: React.ReactNode;
  rightElement?: React.ReactNode;
  isBlock?: boolean;
  isRounded?: boolean;
}

const defaultTheme: ButtonTheme = {
  colorScheme: {
    background: '#0f172a',
    foreground: '#f1f5f9',
    accent: '#06b6d4',
    muted: '#475569'
  },
  spacing: {
    unit: 4
  },
  typography: {
    scale: 1
  }
};

export const Button: React.FC<ButtonProps> = ({
  emphasis = 'high',
  dimension = 'standard',
  theme = {},
  leftElement,
  rightElement,
  isBlock = false,
  isRounded = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as ButtonTheme;
  const unit = appliedTheme.spacing.unit;

  const dimensionConfig = {
    compact: { padding: `${unit * 1}px ${unit * 3}px`, fontSize: `${0.875 * appliedTheme.typography.scale}rem` },
    standard: { padding: `${unit * 2}px ${unit * 4}px`, fontSize: `${1 * appliedTheme.typography.scale}rem` },
    comfortable: { padding: `${unit * 3}px ${unit * 5}px`, fontSize: `${1.0625 * appliedTheme.typography.scale}rem` },
    spacious: { padding: `${unit * 4}px ${unit * 6}px`, fontSize: `${1.125 * appliedTheme.typography.scale}rem` }
  };

  const emphasisConfig = {
    high: {
      backgroundColor: appliedTheme.colorScheme.accent,
      color: appliedTheme.colorScheme.background,
      border: 'none',
      fontWeight: 700
    },
    medium: {
      backgroundColor: appliedTheme.colorScheme.background,
      color: appliedTheme.colorScheme.foreground,
      border: `2px solid ${appliedTheme.colorScheme.accent}`,
      fontWeight: 600
    },
    low: {
      backgroundColor: `${appliedTheme.colorScheme.accent}20`,
      color: appliedTheme.colorScheme.accent,
      border: 'none',
      fontWeight: 500
    },
    minimal: {
      backgroundColor: 'transparent',
      color: appliedTheme.colorScheme.muted,
      border: 'none',
      fontWeight: 400
    }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: `${unit * 2}px`,
    borderRadius: isRounded ? '9999px' : `${unit * 2}px`,
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    width: isBlock ? '100%' : 'auto',
    ...dimensionConfig[dimension],
    ...emphasisConfig[emphasis],
    ...style
  };

  return (
    <button style={baseStyles} {...props}>
      {leftElement && <span style={{ display: 'flex', alignItems: 'center' }}>{leftElement}</span>}
      <span>{children}</span>
      {rightElement && <span style={{ display: 'flex', alignItems: 'center' }}>{rightElement}</span>}
    </button>
  );
};
