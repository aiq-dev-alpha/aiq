import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  surface: string;
  text: string;
}

interface LoginFlowProps {
  theme?: Partial<Theme>;
  onLogin?: (email: string, password: string) => void;
}

const defaultTheme: Theme = {
  primary: '#3b82f6',
  background: '#f3f4f6',
  surface: '#ffffff',
  text: '#1f2937'
};

export const LoginFlow: React.FC<LoginFlowProps> = ({
  theme = {},
  onLogin
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
    backgroundColor: appliedTheme.background,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.surface,
    padding: '2.5rem',
    borderRadius: '1rem',
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
    backgroundColor: appliedTheme.primary,
    color: '#ffffff',
    border: 'none',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer',
    marginTop: '0.5rem'
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <h2 style={{ fontSize: '1.875rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem', textAlign: 'center' }}>Login</h2>
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
          <button type="submit" style={buttonStyles}>Login</button>
        </form>
      </div>
    </div>
  );
};
