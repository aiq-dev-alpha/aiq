import React from 'react';

export interface InputTheme {
  primary: string;
  surface: string;
  text: string;
  muted: string;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  design?: 'minimal' | 'bordered' | 'filled' | 'underline';
  scale?: 'xs' | 'sm' | 'md' | 'lg';
  theme?: Partial<InputTheme>;
  labelText?: string;
  hintText?: string;
  leadingElement?: React.ReactNode;
  trailingElement?: React.ReactNode;
  hasError?: boolean;
  isFullWidth?: boolean;
}

const defaultTheme: InputTheme = {
  primary: '#3b82f6',
  surface: '#f1f5f9',
  text: '#1e293b',
  muted: '#94a3b8'
};

export const Input: React.FC<InputProps> = ({
  design = 'bordered',
  scale = 'md',
  theme = {},
  labelText,
  hintText,
  leadingElement,
  trailingElement,
  hasError = false,
  isFullWidth = false,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const [focused, setFocused] = React.useState(false);

  const scaleMap = {
    xs: { padding: '0.375rem 0.625rem', fontSize: '0.75rem' },
    sm: { padding: '0.5rem 0.875rem', fontSize: '0.875rem' },
    md: { padding: '0.625rem 1rem', fontSize: '1rem' },
    lg: { padding: '0.875rem 1.25rem', fontSize: '1.125rem' }
  };

  const designMap = {
    minimal: {
      backgroundColor: 'transparent',
      border: 'none',
      borderRadius: '0'
    },
    bordered: {
      backgroundColor: '#ffffff',
      border: `2px solid ${hasError ? '#ef4444' : focused ? appliedTheme.primary : '#e2e8f0'}`,
      borderRadius: '0.5rem'
    },
    filled: {
      backgroundColor: appliedTheme.surface,
      border: `2px solid ${hasError ? '#ef4444' : focused ? appliedTheme.primary : 'transparent'}`,
      borderRadius: '0.5rem'
    },
    underline: {
      backgroundColor: 'transparent',
      border: 'none',
      borderBottom: `2px solid ${hasError ? '#ef4444' : focused ? appliedTheme.primary : appliedTheme.muted}`,
      borderRadius: '0'
    }
  };

  const containerStyles: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.5rem',
    width: isFullWidth ? '100%' : 'auto'
  };

  const wrapperStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '0.625rem',
    transition: 'all 0.2s ease',
    ...designMap[design]
  };

  const inputStyles: React.CSSProperties = {
    flex: 1,
    border: 'none',
    outline: 'none',
    backgroundColor: 'transparent',
    color: appliedTheme.text,
    ...scaleMap[scale],
    ...style
  };

  return (
    <div style={containerStyles}>
      {labelText && (
        <label style={{ fontSize: '0.875rem', fontWeight: 600, color: appliedTheme.text }}>
          {labelText}
        </label>
      )}
      <div style={wrapperStyles}>
        {leadingElement && <span style={{ display: 'flex', paddingLeft: design === 'bordered' || design === 'filled' ? '0.5rem' : '0' }}>{leadingElement}</span>}
        <input
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          style={inputStyles}
          {...props}
        />
        {trailingElement && <span style={{ display: 'flex', paddingRight: design === 'bordered' || design === 'filled' ? '0.5rem' : '0' }}>{trailingElement}</span>}
      </div>
      {hintText && (
        <span style={{ fontSize: '0.75rem', color: hasError ? '#ef4444' : appliedTheme.muted }}>
          {hintText}
        </span>
      )}
    </div>
  );
};
