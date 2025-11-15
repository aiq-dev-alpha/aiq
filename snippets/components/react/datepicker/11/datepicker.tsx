import React from 'react';

export interface ComponentTheme {
  primary: string;
  secondary: string;
  background: string;
  text: string;
  border: string;
}

export interface ComponentProps {
  theme?: Partial<ComponentTheme>;
  variant?: 'default' | 'outlined' | 'filled';
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
}

const defaultTheme: ComponentTheme = {
  primary: '#3b82f6',
  secondary: '#8b5cf6',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const Component: React.FC<ComponentProps> = ({
  theme = {},
  variant = 'default',
  size = 'md'
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  
  const sizeMap = {
    xs: { padding: '0.25rem 0.5rem', fontSize: '0.75rem' },
    sm: { padding: '0.5rem 1rem', fontSize: '0.875rem' },
    md: { padding: '0.75rem 1.5rem', fontSize: '1rem' },
    lg: { padding: '1rem 2rem', fontSize: '1.125rem' },
    xl: { padding: '1.25rem 2.5rem', fontSize: '1.25rem' }
  };

  const variantMap = {
    default: {
      backgroundColor: appliedTheme.background,
      border: `1px solid ${appliedTheme.border}`
    },
    outlined: {
      backgroundColor: 'transparent',
      border: `2px solid ${appliedTheme.primary}`
    },
    filled: {
      backgroundColor: appliedTheme.primary,
      border: 'none'
    }
  };

  const styles: React.CSSProperties = {
    color: appliedTheme.text,
    borderRadius: '0.5rem',
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    transition: 'all 0.2s ease',
    ...sizeMap[size],
    ...variantMap[variant]
  };

  return <div style={styles}>Component</div>;
};
