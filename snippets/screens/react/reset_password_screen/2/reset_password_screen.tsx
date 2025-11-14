import React, { useState } from 'react';
import './reset_password_screen.css';

// Version 2: Modern card-based with real-time validation

interface PasswordRequirement {
  label: string;
  test: (pwd: string) => boolean;
}

export const ResetPasswordScreen: React.FC = () => {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);

  const requirements: PasswordRequirement[] = [
    { label: 'At least 8 characters', test: (pwd) => pwd.length >= 8 },
    { label: 'One uppercase letter', test: (pwd) => /[A-Z]/.test(pwd) },
    { label: 'One lowercase letter', test: (pwd) => /[a-z]/.test(pwd) },
    { label: 'One number', test: (pwd) => /\d/.test(pwd) },
    { label: 'One special character', test: (pwd) => /[^A-Za-z0-9]/.test(pwd) },
  ];

  const allRequirementsMet = requirements.every(req => req.test(password));
  const passwordsMatch = password && confirmPassword && password === confirmPassword;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!allRequirementsMet || !passwordsMatch) return;

    setIsLoading(true);
    await new Promise(resolve => setTimeout(resolve, 1500));
    setIsLoading(false);
    setIsSuccess(true);
  };

  if (isSuccess) {
    return (
      <div className="modern-reset-container">
        <div className="modern-reset-card">
          <div className="success-animation">
            <div className="success-circle">
              <div className="checkmark">✓</div>
            </div>
          </div>

          <h1 className="success-title">Password Reset!</h1>
          <p className="success-message">
            Your password has been successfully reset.
            You can now sign in with your new password.
          </p>

          <button
            className="modern-btn primary"
            onClick={() => window.location.href = '#'}
          >
            Go to Sign In
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-reset-container">
      <div className="modern-reset-card">
        <div className="icon-lock">
          <div className="lock-body-modern"></div>
          <div className="lock-shackle-modern"></div>
        </div>

        <h1 className="modern-reset-title">Create New Password</h1>
        <p className="modern-reset-subtitle">
          Your new password must be different from previously used passwords.
        </p>

        <form onSubmit={handleSubmit} className="modern-reset-form">
          <div className="input-container">
            <label className="modern-label">New Password</label>
            <div className="password-input-wrapper">
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="modern-input"
                placeholder="Enter new password"
              />
              <button
                type="button"
                className="toggle-visibility"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword ? '👁️' : '👁️‍🗨️'}
              </button>
            </div>
          </div>

          <div className="requirements-grid">
            {requirements.map((req, index) => (
              <div
                key={index}
                className={`requirement-item ${req.test(password) ? 'met' : ''}`}
              >
                <div className="requirement-icon">
                  {req.test(password) ? '✓' : '○'}
                </div>
                <span>{req.label}</span>
              </div>
            ))}
          </div>

          <div className="input-container">
            <label className="modern-label">Confirm Password</label>
            <input
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className={`modern-input ${confirmPassword && !passwordsMatch ? 'error' : ''} ${passwordsMatch ? 'success' : ''}`}
              placeholder="Re-enter password"
            />
            {confirmPassword && !passwordsMatch && (
              <span className="error-hint">Passwords do not match</span>
            )}
            {passwordsMatch && (
              <span className="success-hint">✓ Passwords match</span>
            )}
          </div>

          <button
            type="submit"
            className="modern-btn primary"
            disabled={!allRequirementsMet || !passwordsMatch || isLoading}
          >
            {isLoading ? (
              <div className="loading-state">
                <div className="spinner-modern"></div>
                <span>Resetting...</span>
              </div>
            ) : (
              'Reset Password'
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

export default ResetPasswordScreen;
