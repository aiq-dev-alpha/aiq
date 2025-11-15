import React from 'react';

export interface ComponentTheme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  borderColor: string;
}

export interface ComponentProps {
  theme?: Partial<ComponentTheme>;
  size?: 'sm' | 'md' | 'lg';
}

const defaultTheme: ComponentTheme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#ffffff',
  textColor: '#111827',
  borderColor: '#e5e7eb'
};

export const Component: React.FC<ComponentProps> = ({ theme = {}, size = 'md' }) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  
  const styles: React.CSSProperties = {
    padding: size === 'sm' ? '0.5rem' : size === 'lg' ? '1.5rem' : '1rem',
    backgroundColor: appliedTheme.backgroundColor,
    color: appliedTheme.textColor,
    border: `1px solid ${appliedTheme.borderColor}`,
    borderRadius: '0.5rem'
  };

  return <div style={styles}>Component</div>;
};
