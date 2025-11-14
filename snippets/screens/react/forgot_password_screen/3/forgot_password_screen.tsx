import React, { useState } from 'react';
import './forgot_password_screen.css';

// Version 3: Ultra-minimal design with clean typography

export const ForgotPasswordScreen: React.FC = () => {
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);
  const [isFocused, setIsFocused] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim()) return;

    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 1200));
    setIsLoading(false);
    setEmailSent(true);
  };

  if (emailSent) {
    return (
      <div className="minimal-forgot">
        <div className="minimal-content">
          <div className="success-indicator">
            <div className="checkmark-line"></div>
            <div className="checkmark-line checkmark-line-tip"></div>
          </div>

          <h1 className="minimal-h1">Check your inbox</h1>
          
          <div className="email-sent-info">
            <p>We sent a recovery link to</p>
            <strong>{email}</strong>
          </div>

          <div className="minimal-divider"></div>

          <div className="action-group">
            <button
              className="minimal-link-btn"
              onClick={() => setEmailSent(false)}
            >
              Try another email
            </button>
            <span className="dot-separator">•</span>
            <a href="#" className="minimal-link-btn">
              Back to sign in
            </a>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="minimal-forgot">
      <div className="minimal-content">
        <div className="header-section">
          <h1 className="minimal-h1">Reset password</h1>
          <p className="minimal-description">
            Enter your email address and we'll send you a link to get back into your account.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="minimal-form-section">
          <div className={`minimal-input-wrapper ${isFocused || email ? 'active' : ''}`}>
            <label htmlFor="email" className="minimal-label">
              Email address
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              onFocus={() => setIsFocused(true)}
              onBlur={() => setIsFocused(false)}
              className="minimal-input"
              required
            />
            <div className="minimal-underline"></div>
          </div>

          <button
            type="submit"
            className="minimal-submit-btn"
            disabled={isLoading || !email}
          >
            {isLoading ? (
              <span className="loading-text">
                Sending<span className="dots"></span>
              </span>
            ) : (
              'Send recovery link'
            )}
          </button>
        </form>

        <div className="minimal-footer">
          <a href="#" className="back-to-login">
            ← Back to sign in
          </a>
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordScreen;
