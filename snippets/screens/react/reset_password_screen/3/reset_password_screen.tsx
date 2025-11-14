import React, { useState } from 'react';
import './reset_password_screen.css';

// Version 3: Minimal clean design

export const ResetPasswordScreen: React.FC = () => {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [focusedField, setFocusedField] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const isPasswordValid = password.length >= 8 && /[A-Z]/.test(password) && /[a-z]/.test(password) && /\d/.test(password);
  const passwordsMatch = password && confirmPassword && password === confirmPassword;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!isPasswordValid || !passwordsMatch) return;

    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 1200));
    setIsLoading(false);
    setIsSuccess(true);
  };

  if (isSuccess) {
    return (
      <div className="minimal-reset">
        <div className="minimal-reset-content">
          <div className="success-mark">✓</div>
          <h1 className="minimal-reset-h1">All set</h1>
          <p className="minimal-reset-p">
            Your password has been reset successfully.
          </p>
          <a href="#" className="minimal-link-primary">
            Continue to sign in
          </a>
        </div>
      </div>
    );
  }

  return (
    <div className="minimal-reset">
      <div className="minimal-reset-content">
        <h1 className="minimal-reset-h1">New password</h1>
        <p className="minimal-reset-p">
          Choose a strong password with at least 8 characters.
        </p>

        <form onSubmit={handleSubmit} className="minimal-reset-form">
          <div className={`minimal-field-group ${focusedField === 'password' ? 'focused' : ''} ${password ? 'filled' : ''}`}>
            <label htmlFor="password" className="minimal-field-label">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              onFocus={() => setFocusedField('password')}
              onBlur={() => setFocusedField(null)}
              className="minimal-field-input"
              required
            />
            <div className="minimal-field-line"></div>
          </div>

          {password && !isPasswordValid && (
            <p className="minimal-hint">
              Must be 8+ characters with uppercase, lowercase, and numbers
            </p>
          )}

          <div className={`minimal-field-group ${focusedField === 'confirm' ? 'focused' : ''} ${confirmPassword ? 'filled' : ''}`}>
            <label htmlFor="confirm" className="minimal-field-label">
              Confirm password
            </label>
            <input
              id="confirm"
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              onFocus={() => setFocusedField('confirm')}
              onBlur={() => setFocusedField(null)}
              className="minimal-field-input"
              required
            />
            <div className="minimal-field-line"></div>
          </div>

          {confirmPassword && !passwordsMatch && (
            <p className="minimal-hint error">
              Passwords do not match
            </p>
          )}

          <button
            type="submit"
            className="minimal-submit"
            disabled={!isPasswordValid || !passwordsMatch || isLoading}
          >
            {isLoading ? 'Resetting...' : 'Reset password'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default ResetPasswordScreen;
