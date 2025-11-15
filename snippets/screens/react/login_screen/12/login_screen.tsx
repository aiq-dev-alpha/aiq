import React, { useState } from 'react';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  cardBackground: string;
  textColor: string;
}

interface LoginScreenProps {
  theme?: Partial<Theme>;
  onLogin?: (email: string, password: string) => void;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primaryColor: '#6366f1',
  backgroundColor: '#f5f5f5',
  cardBackground: '#ffffff',
  textColor: '#1f2937'
};

export const LoginScreen: React.FC<LoginScreenProps> = ({
  theme = {},
  onLogin,
  styles = {}
}) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const appliedTheme = { ...defaultTheme, ...theme };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin?.(email, password);
  };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    padding: '2.5rem',
    borderRadius: '0.75rem',
    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
    maxWidth: '400px',
    width: '100%'
  };

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1rem'
  };

  const buttonStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.875rem',
    backgroundColor: appliedTheme.primaryColor,
    color: '#ffffff',
    border: 'none',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer'
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <h1 style={{ fontSize: '1.875rem', fontWeight: 700, color: appliedTheme.textColor, marginBottom: '1.5rem', textAlign: 'center' }}>Sign In</h1>
        <form onSubmit={handleSubmit}>
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            style={inputStyles}
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            style={inputStyles}
          />
          <button type="submit" style={buttonStyles}>Sign In</button>
        </form>
      </div>
    </div>
  );
};
