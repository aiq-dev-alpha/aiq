import React, { useState } from 'react';
import './forgot_password_screen.css';

// Version 2: Modern animated card design with gradient background

export const ForgotPasswordScreen: React.FC = () => {
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);
  const [error, setError] = useState('');
  const [countdown, setCountdown] = useState(0);

  const validateEmail = (email: string): boolean => {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!email.trim()) {
      setError('Please enter your email address');
      return;
    }

    if (!validateEmail(email)) {
      setError('Please enter a valid email address');
      return;
    }

    setIsLoading(true);
    setError('');

    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1500));

    setIsLoading(false);
    setEmailSent(true);
    setCountdown(60);

    // Start countdown timer
    const timer = setInterval(() => {
      setCountdown(prev => {
        if (prev <= 1) {
          clearInterval(timer);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  };

  const handleResend = async () => {
    if (countdown > 0) return;

    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsLoading(false);
    setCountdown(60);
  };

  if (emailSent) {
    return (
      <div className="modern-forgot-container">
        <div className="modern-card success-card">
          <div className="animated-checkmark">
            <svg className="checkmark" viewBox="0 0 52 52">
              <circle className="checkmark-circle" cx="26" cy="26" r="25" fill="none"/>
              <path className="checkmark-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
            </svg>
          </div>

          <h1 className="modern-title">Email Sent!</h1>
          <p className="modern-subtitle">
            We've sent a password reset link to
          </p>
          <p className="email-display">{email}</p>

          <div className="info-box">
            <div className="info-icon">💡</div>
            <p>The link will expire in 15 minutes. Check your spam folder if you don't see it.</p>
          </div>

          <button
            className="modern-button primary"
            onClick={() => window.location.href = '#'}
            disabled={isLoading}
          >
            <span className="button-icon">✉️</span>
            Open Email App
          </button>

          <button
            className={`modern-button secondary ${countdown > 0 ? 'disabled' : ''}`}
            onClick={handleResend}
            disabled={countdown > 0 || isLoading}
          >
            {countdown > 0 ? (
              <>Resend in {countdown}s</>
            ) : (
              <>
                <span className="button-icon">🔄</span>
                Resend Link
              </>
            )}
          </button>

          <button
            className="back-link"
            onClick={() => setEmailSent(false)}
          >
            Use different email
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-forgot-container">
      <div className="modern-card">
        <div className="icon-container">
          <div className="lock-icon">
            <div className="lock-body">
              <div className="lock-keyhole"></div>
            </div>
            <div className="lock-shackle"></div>
          </div>
        </div>

        <h1 className="modern-title">Forgot Password?</h1>
        <p className="modern-subtitle">
          No worries! Enter your email and we'll send you reset instructions.
        </p>

        <form onSubmit={handleSubmit} className="modern-form">
          <div className="input-group">
            <div className="input-icon">📧</div>
            <input
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value);
                setError('');
              }}
              className={error ? 'error' : ''}
              disabled={isLoading}
            />
          </div>

          {error && (
            <div className="error-message">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          <button
            type="submit"
            className="modern-button primary"
            disabled={isLoading}
          >
            {isLoading ? (
              <div className="loading-spinner">
                <div className="spinner"></div>
                <span>Sending...</span>
              </div>
            ) : (
              <>
                <span className="button-icon">🚀</span>
                Send Reset Link
              </>
            )}
          </button>

          <button
            type="button"
            className="modern-button secondary"
            onClick={() => window.history.back()}
          >
            <span className="button-icon">←</span>
            Back to Sign In
          </button>
        </form>

        <div className="help-text">
          <span className="help-icon">🔒</span>
          Your data is safe with us. We use industry-standard encryption.
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordScreen;
