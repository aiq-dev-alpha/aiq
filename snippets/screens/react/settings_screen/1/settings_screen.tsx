import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  card: string;
  text: string;
  textMuted: string;
  border: string;
}

interface SettingsScreenProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primary: '#3b82f6',
  background: '#f9fafb',
  card: '#ffffff',
  text: '#111827',
  textMuted: '#6b7280',
  border: '#e5e7eb'
};

export const SettingsScreen: React.FC<SettingsScreenProps> = ({
  theme = {},
  styles = {}
}) => {
  const [notifications, setNotifications] = useState(true);
  const [emailUpdates, setEmailUpdates] = useState(false);
  const [darkMode, setDarkMode] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.background,
    padding: '3rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const contentStyles: React.CSSProperties = {
    maxWidth: '800px',
    margin: '0 auto'
  };

  const sectionStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.card,
    padding: '2rem',
    borderRadius: '0.75rem',
    marginBottom: '1.5rem',
    border: `1px solid ${appliedTheme.border}`
  };

  const rowStyles: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '1rem 0',
    borderBottom: `1px solid ${appliedTheme.border}`
  };

  const toggleStyles: React.CSSProperties = {
    width: '3rem',
    height: '1.75rem',
    borderRadius: '9999px',
    cursor: 'pointer',
    transition: 'background-color 0.2s'
  };

  return (
    <div style={containerStyles}>
      <div style={contentStyles}>
        <h1 style={{ fontSize: '2.5rem', fontWeight: 800, color: appliedTheme.text, marginBottom: '0.5rem' }}>Settings</h1>
        <p style={{ fontSize: '1rem', color: appliedTheme.textMuted, marginBottom: '2rem' }}>Manage your account preferences</p>

        <div style={sectionStyles}>
          <h2 style={{ fontSize: '1.25rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem' }}>Notifications</h2>
          <div style={rowStyles}>
            <div>
              <div style={{ fontWeight: 600, color: appliedTheme.text }}>Push Notifications</div>
              <div style={{ fontSize: '0.875rem', color: appliedTheme.textMuted }}>Receive push notifications on your device</div>
            </div>
            <div
              style={{ ...toggleStyles, backgroundColor: notifications ? appliedTheme.primary : '#d1d5db' }}
              onClick={() => setNotifications(!notifications)}
            />
          </div>
          <div style={rowStyles}>
            <div>
              <div style={{ fontWeight: 600, color: appliedTheme.text }}>Email Updates</div>
              <div style={{ fontSize: '0.875rem', color: appliedTheme.textMuted }}>Get email about product updates</div>
            </div>
            <div
              style={{ ...toggleStyles, backgroundColor: emailUpdates ? appliedTheme.primary : '#d1d5db' }}
              onClick={() => setEmailUpdates(!emailUpdates)}
            />
          </div>
        </div>

        <div style={sectionStyles}>
          <h2 style={{ fontSize: '1.25rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem' }}>Appearance</h2>
          <div style={{ ...rowStyles, borderBottom: 'none' }}>
            <div>
              <div style={{ fontWeight: 600, color: appliedTheme.text }}>Dark Mode</div>
              <div style={{ fontSize: '0.875rem', color: appliedTheme.textMuted }}>Use dark theme across the app</div>
            </div>
            <div
              style={{ ...toggleStyles, backgroundColor: darkMode ? appliedTheme.primary : '#d1d5db' }}
              onClick={() => setDarkMode(!darkMode)}
            />
          </div>
        </div>
      </div>
    </div>
  );
};
