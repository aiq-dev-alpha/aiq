import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  card: string;
  text: string;
  border: string;
}

interface SettingsScreenProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primary: '#8b5cf6',
  background: '#fafafa',
  card: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const SettingsScreen: React.FC<SettingsScreenProps> = ({
  theme = {},
  styles = {}
}) => {
  const [notifications, setNotifications] = useState(true);
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.background,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.card,
    padding: '1.5rem',
    borderRadius: '0.75rem',
    marginBottom: '1.5rem',
    border: `1px solid ${appliedTheme.border}`
  };

  const toggleStyles: React.CSSProperties = {
    width: '3rem',
    height: '1.5rem',
    borderRadius: '9999px',
    backgroundColor: notifications ? appliedTheme.primary : '#d1d5db',
    cursor: 'pointer'
  };

  return (
    <div style={containerStyles}>
      <h1 style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '2rem' }}>Settings</h1>
      <div style={cardStyles}>
        <h2 style={{ fontSize: '1.125rem', fontWeight: 600, color: appliedTheme.text, marginBottom: '1rem' }}>Preferences</h2>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ color: appliedTheme.text }}>Enable Notifications</span>
          <div style={toggleStyles} onClick={() => setNotifications(!notifications)} />
        </div>
      </div>
    </div>
  );
};
