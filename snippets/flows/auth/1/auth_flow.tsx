import React, { useState } from 'react';

type AuthView = 'login' | 'register' | 'forgot-password' | 'reset-password';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  cardBackground: string;
  errorColor: string;
}

interface AuthFlowProps {
  onLogin?: (email: string, password: string) => Promise<void>;
  onRegister?: (email: string, password: string, name: string) => Promise<void>;
  onForgotPassword?: (email: string) => Promise<void>;
  onResetPassword?: (code: string, newPassword: string) => Promise<void>;
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#f9fafb',
  textColor: '#111827',
  cardBackground: '#ffffff',
  errorColor: '#ef4444'
};

export const AuthFlow: React.FC<AuthFlowProps> = ({
  onLogin,
  onRegister,
  onForgotPassword,
  onResetPassword,
  theme = {}
}) => {
  const [view, setView] = useState<AuthView>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [code, setCode] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const appliedTheme = { ...defaultTheme, ...theme };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await onLogin?.(email, password);
    } catch (err) {
      setError('Login failed. Please check your credentials.');
    } finally {
      setLoading(false);
    }
  };

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await onRegister?.(email, password, name);
    } catch (err) {
      setError('Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleForgotPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await onForgotPassword?.(email);
      setView('reset-password');
    } catch (err) {
      setError('Failed to send reset code.');
    } finally {
      setLoading(false);
    }
  };

  const handleResetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      await onResetPassword?.(code, password);
      setView('login');
    } catch (err) {
      setError('Failed to reset password.');
    } finally {
      setLoading(false);
    }
  };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    borderRadius: '1rem',
    padding: '2.5rem',
    maxWidth: '400px',
    width: '100%',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '1.875rem',
    fontWeight: 700,
    color: appliedTheme.textColor,
    marginBottom: '0.5rem',
    textAlign: 'center'
  };

  const subtitleStyles: React.CSSProperties = {
    fontSize: '1rem',
    color: '#6b7280',
    marginBottom: '2rem',
    textAlign: 'center'
  };

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem 1rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1rem',
    fontFamily: 'inherit'
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
    cursor: loading ? 'not-allowed' : 'pointer',
    opacity: loading ? 0.6 : 1,
    marginTop: '1rem'
  };

  const linkStyles: React.CSSProperties = {
    color: appliedTheme.primaryColor,
    cursor: 'pointer',
    textDecoration: 'none'
  };

  const errorStyles: React.CSSProperties = {
    color: appliedTheme.errorColor,
    fontSize: '0.875rem',
    marginBottom: '1rem',
    textAlign: 'center'
  };

  const renderView = () => {
    switch (view) {
      case 'login':
        return (
          <>
            <h1 style={titleStyles}>Welcome Back</h1>
            <p style={subtitleStyles}>Sign in to continue</p>
            {error && <div style={errorStyles}>{error}</div>}
            <form onSubmit={handleLogin}>
              <input
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                style={inputStyles}
                required
              />
              <input
                type="password"
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                style={inputStyles}
                required
              />
              <div style={{ textAlign: 'right', marginBottom: '1rem' }}>
                <span style={linkStyles} onClick={() => setView('forgot-password')}>
                  Forgot Password?
                </span>
              </div>
              <button type="submit" style={buttonStyles} disabled={loading}>
                {loading ? 'Signing in...' : 'Sign In'}
              </button>
            </form>
            <div style={{ textAlign: 'center', marginTop: '1.5rem' }}>
              <span style={{ color: '#6b7280' }}>Don't have an account? </span>
              <span style={linkStyles} onClick={() => setView('register')}>
                Sign Up
              </span>
            </div>
          </>
        );

      case 'register':
        return (
          <>
            <h1 style={titleStyles}>Create Account</h1>
            <p style={subtitleStyles}>Sign up to get started</p>
            {error && <div style={errorStyles}>{error}</div>}
            <form onSubmit={handleRegister}>
              <input
                type="text"
                placeholder="Full Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                style={inputStyles}
                required
              />
              <input
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                style={inputStyles}
                required
              />
              <input
                type="password"
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                style={inputStyles}
                required
              />
              <button type="submit" style={buttonStyles} disabled={loading}>
                {loading ? 'Creating account...' : 'Sign Up'}
              </button>
            </form>
            <div style={{ textAlign: 'center', marginTop: '1.5rem' }}>
              <span style={{ color: '#6b7280' }}>Already have an account? </span>
              <span style={linkStyles} onClick={() => setView('login')}>
                Sign In
              </span>
            </div>
          </>
        );

      case 'forgot-password':
        return (
          <>
            <h1 style={titleStyles}>Forgot Password</h1>
            <p style={subtitleStyles}>Enter your email to receive a reset code</p>
            {error && <div style={errorStyles}>{error}</div>}
            <form onSubmit={handleForgotPassword}>
              <input
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                style={inputStyles}
                required
              />
              <button type="submit" style={buttonStyles} disabled={loading}>
                {loading ? 'Sending...' : 'Send Reset Code'}
              </button>
            </form>
            <div style={{ textAlign: 'center', marginTop: '1.5rem' }}>
              <span style={linkStyles} onClick={() => setView('login')}>
                Back to Sign In
              </span>
            </div>
          </>
        );

      case 'reset-password':
        return (
          <>
            <h1 style={titleStyles}>Reset Password</h1>
            <p style={subtitleStyles}>Enter the code and your new password</p>
            {error && <div style={errorStyles}>{error}</div>}
            <form onSubmit={handleResetPassword}>
              <input
                type="text"
                placeholder="Reset Code"
                value={code}
                onChange={(e) => setCode(e.target.value)}
                style={inputStyles}
                required
              />
              <input
                type="password"
                placeholder="New Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                style={inputStyles}
                required
              />
              <button type="submit" style={buttonStyles} disabled={loading}>
                {loading ? 'Resetting...' : 'Reset Password'}
              </button>
            </form>
            <div style={{ textAlign: 'center', marginTop: '1.5rem' }}>
              <span style={linkStyles} onClick={() => setView('login')}>
                Back to Sign In
              </span>
            </div>
          </>
        );

      default:
        return null;
    }
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        {renderView()}
      </div>
    </div>
  );
};
