import React, { useState, FormEvent } from 'react';
import './login_screen.css';

// Version 3: Minimal split-screen design

interface FormErrors {
  email?: string;
  password?: string;
}

export const LoginScreen: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (!email.trim()) {
      newErrors.email = 'Required';
    }

    if (!password) {
      newErrors.password = 'Required';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!validateForm()) return;

    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1500));
      console.log('Authenticated');
    } catch (error) {
      console.error(error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="minimal-login">
      <div className="visual-panel">
        <div className="visual-content">
          <div className="geometric-pattern">
            <div className="circle circle-1" />
            <div className="circle circle-2" />
            <div className="circle circle-3" />
          </div>
          <h2 className="visual-title">Welcome to AIQ</h2>
          <p className="visual-description">
            Build better applications with our comprehensive development platform
          </p>
          <div className="feature-list">
            <div className="feature-item">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              <span>Secure authentication</span>
            </div>
            <div className="feature-item">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              <span>Cloud-based infrastructure</span>
            </div>
            <div className="feature-item">
              <svg viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              <span>24/7 support</span>
            </div>
          </div>
        </div>
      </div>

      <div className="form-panel">
        <div className="form-container">
          <div className="minimal-header">
            <h1>Sign in</h1>
            <p>Enter your credentials</p>
          </div>

          <form onSubmit={handleSubmit} className="minimal-form">
            <div className="minimal-input-group">
              <input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder=" "
                className={`minimal-input ${errors.email ? 'has-error' : ''}`}
                autoComplete="email"
              />
              <label htmlFor="email" className="minimal-label">Email</label>
              {errors.email && <span className="minimal-error">{errors.email}</span>}
            </div>

            <div className="minimal-input-group">
              <input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder=" "
                className={`minimal-input ${errors.password ? 'has-error' : ''}`}
                autoComplete="current-password"
              />
              <label htmlFor="password" className="minimal-label">Password</label>
              {errors.password && <span className="minimal-error">{errors.password}</span>}
            </div>

            <div className="minimal-options">
              <a href="#" className="minimal-link">Forgot password?</a>
            </div>

            <button
              type="submit"
              className="minimal-submit"
              disabled={isLoading}
            >
              {isLoading ? (
                <div className="minimal-spinner" />
              ) : (
                'Continue'
              )}
            </button>

            <div className="minimal-footer">
              <span>New to AIQ?</span>
              <a href="#" className="minimal-link bold">Create account</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};
