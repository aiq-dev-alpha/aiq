import React from 'react';

interface Theme {
  primary: string;
  background: string;
  text: string;
}

interface ScreenProps {
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  primary: '#6366f1',
  background: '#f9fafb',
  text: '#111827'
};

export const Screen: React.FC<ScreenProps> = ({ theme = {} }) => {
  const appliedTheme = { ...defaultTheme, ...theme };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: appliedTheme.background, padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.text }}>Screen</h1>
      <div style={{ marginTop: '2rem', backgroundColor: '#ffffff', padding: '1.5rem', borderRadius: '0.75rem', boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)' }}>
        <p style={{ color: appliedTheme.text }}>Content goes here</p>
      </div>
    </div>
  );
};
