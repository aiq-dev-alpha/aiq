import React from 'react';

interface Theme {
  primary: string;
  secondary: string;
  background: string;
  surface: string;
  text: string;
  textSecondary: string;
}

interface ScreenProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primary: '#6366f1',
  secondary: '#8b5cf6',
  background: '#f9fafb',
  surface: '#ffffff',
  text: '#111827',
  textSecondary: '#6b7280'
};

export const Screen: React.FC<ScreenProps> = ({ theme = {}, styles = {} }) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.background,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const headerStyles: React.CSSProperties = {
    marginBottom: '2rem'
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '2rem',
    fontWeight: 700,
    color: appliedTheme.text,
    marginBottom: '0.5rem'
  };

  const contentStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.surface,
    padding: '1.5rem',
    borderRadius: '0.75rem',
    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
  };

  return (
    <div style={containerStyles}>
      <div style={headerStyles}>
        <h1 style={titleStyles}>Screen Title</h1>
        <p style={{ color: appliedTheme.textSecondary }}>Screen description</p>
      </div>
      <div style={contentStyles}>
        <p style={{ color: appliedTheme.text }}>Main content area</p>
      </div>
    </div>
  );
};
