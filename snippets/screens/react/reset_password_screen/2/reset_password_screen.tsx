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
      <div className="modern_reset_container">
        <div className="modern_reset_card">
          <div className="success_animation">
            <div className="success_circle">
              <div className="checkmark">✓</div>
            </div>
          </div>

          <h1 className="success_title">Password Reset!</h1>
          <p className="success_message">
            Your password has been successfully reset.
            You can now sign in with your new password.
          </p>

          <button
            className="modern_btn primary"
            onClick={() => window.location.href = '#'}
          >
            Go to Sign In
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="modern_reset_container">
      <div className="modern_reset_card">
        <div className="icon_lock">
          <div className="lock_body_modern"></div>
          <div className="lock_shackle_modern"></div>
        </div>

        <h1 className="modern_reset_title">Create New Password</h1>
        <p className="modern_reset_subtitle">
          Your new password must be different from previously used passwords.
        </p>

        <form onSubmit={handleSubmit} className="modern_reset_form">
          <div className="input_container">
            <label className="modern_label">New Password</label>
            <div className="password_input_wrapper">
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="modern_input"
                placeholder="Enter new password"
              />
              <button
                type="button"
                className="toggle_visibility"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword ? '👁️' : '👁️‍🗨️'}
              </button>
            </div>
          </div>

          <div className="requirements_grid">
            {requirements.map((req, index) => (
              <div
                key={index}
                className={`requirement_item ${req.test(password) ? 'met' : ''}`}
              >
                <div className="requirement_icon">
                  {req.test(password) ? '✓' : '○'}
                </div>
                <span>{req.label}</span>
              </div>
            ))}
          </div>

          <div className="input_container">
            <label className="modern_label">Confirm Password</label>
            <input
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className={`modern_input ${confirmPassword && !passwordsMatch ? 'error' : ''} ${passwordsMatch ? 'success' : ''}`}
              placeholder="Re-enter password"
            />
            {confirmPassword && !passwordsMatch && (
              <span className="error_hint">Passwords do not match</span>
            )}
            {passwordsMatch && (
              <span className="success_hint">✓ Passwords match</span>
            )}
          </div>

          <button
            type="submit"
            className="modern_btn primary"
            disabled={!allRequirementsMet || !passwordsMatch || isLoading}
          >
            {isLoading ? (
              <div className="loading_state">
                <div className="spinner_modern"></div>
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
