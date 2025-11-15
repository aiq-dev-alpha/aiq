import React, { useState } from 'react';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  cardBackground: string;
  textColor: string;
  accentColor: string;
}

interface DashboardProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#f9fafb',
  cardBackground: '#ffffff',
  textColor: '#111827',
  accentColor: '#8b5cf6'
};

export const DashboardScreen: React.FC<DashboardProps> = ({
  theme = {},
  styles = {}
}) => {
  const [filter, setFilter] = useState('all');
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const gridStyles: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
    gap: '1.5rem',
    marginTop: '2rem'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    padding: '1.5rem',
    borderRadius: '0.75rem',
    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
  };

  return (
    <div style={containerStyles}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.textColor, marginBottom: '1rem' }}>Dashboard</h1>
      <div style={gridStyles}>
        <div style={cardStyles}>
          <h3 style={{ fontSize: '0.875rem', color: '#6b7280', marginBottom: '0.5rem' }}>Total Users</h3>
          <p style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.textColor }}>12,345</p>
        </div>
        <div style={cardStyles}>
          <h3 style={{ fontSize: '0.875rem', color: '#6b7280', marginBottom: '0.5rem' }}>Revenue</h3>
          <p style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.textColor }}>$45,678</p>
        </div>
        <div style={cardStyles}>
          <h3 style={{ fontSize: '0.875rem', color: '#6b7280', marginBottom: '0.5rem' }}>Active Sessions</h3>
          <p style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.textColor }}>789</p>
        </div>
      </div>
    </div>
  );
};
