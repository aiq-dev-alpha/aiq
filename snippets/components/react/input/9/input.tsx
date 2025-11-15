import React from 'react';

export interface InputTheme {
  colors: {
    border: string;
    focusBorder: string;
    background: string;
    text: string;
    placeholder: string;
    label: string;
  };
  spacing: { padding: string; gap: string };
  borderRadius: string;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  helperText?: string;
  theme?: Partial<InputTheme>;
  leftAddon?: React.ReactNode;
  rightAddon?: React.ReactNode;
  inputSize?: 'sm' | 'md' | 'lg';
}

const defaultTheme: InputTheme = {
  colors: {
    border: '#d1d5db',
    focusBorder: '#3b82f6',
    background: '#ffffff',
    text: '#1f2937',
    placeholder: '#9ca3af',
    label: '#374151'
  },
  spacing: { padding: '0.625rem', gap: '0.5rem' },
  borderRadius: '0.5rem'
};

export const Input: React.FC<InputProps> = ({
  label,
  error,
  helperText,
  theme = {},
  leftAddon,
  rightAddon,
  inputSize = 'md',
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme } as InputTheme;
  const [isFocused, setIsFocused] = React.useState(false);

  const sizeConfig = {
    sm: { padding: '0.5rem', fontSize: '0.875rem' },
    md: { padding: '0.625rem', fontSize: '1rem' },
    lg: { padding: '0.75rem', fontSize: '1.125rem' }
  };

  const containerStyles: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: appliedTheme.spacing.gap,
    width: '100%'
  };

  const labelStyles: React.CSSProperties = {
    fontSize: '0.875rem',
    fontWeight: 600,
    color: appliedTheme.colors.label
  };

  const inputWrapperStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '0.5rem',
    backgroundColor: appliedTheme.colors.background,
    border: `2px solid ${error ? '#ef4444' : isFocused ? appliedTheme.colors.focusBorder : appliedTheme.colors.border}`,
    borderRadius: appliedTheme.borderRadius,
    transition: 'border-color 0.2s ease'
  };

  const inputStyles: React.CSSProperties = {
    flex: 1,
    border: 'none',
    outline: 'none',
    backgroundColor: 'transparent',
    color: appliedTheme.colors.text,
    ...sizeConfig[inputSize],
    ...style
  };

  const helperStyles: React.CSSProperties = {
    fontSize: '0.75rem',
    color: error ? '#ef4444' : '#6b7280'
  };

  return (
    <div style={containerStyles}>
      {label && <label style={labelStyles}>{label}</label>}
      <div style={inputWrapperStyles}>
        {leftAddon && <span style={{ paddingLeft: '0.75rem', display: 'flex' }}>{leftAddon}</span>}
        <input
          onFocus={() => setIsFocused(true)}
          onBlur={() => setIsFocused(false)}
          style={inputStyles}
          {...props}
        />
        {rightAddon && <span style={{ paddingRight: '0.75rem', display: 'flex' }}>{rightAddon}</span>}
      </div>
      {(error || helperText) && <span style={helperStyles}>{error || helperText}</span>}
    </div>
  );
};
