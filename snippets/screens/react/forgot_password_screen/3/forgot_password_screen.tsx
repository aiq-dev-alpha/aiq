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
      <div className="minimal_forgot">
        <div className="minimal_content">
          <div className="success_indicator">
            <div className="checkmark_line"></div>
            <div className="checkmark_line checkmark_line_tip"></div>
          </div>

          <h1 className="minimal_h1">Check your inbox</h1>
          
          <div className="email_sent_info">
            <p>We sent a recovery link to</p>
            <strong>{email}</strong>
          </div>

          <div className="minimal_divider"></div>

          <div className="action_group">
            <button
              className="minimal_link_btn"
              onClick={() => setEmailSent(false)}
            >
              Try another email
            </button>
            <span className="dot_separator">•</span>
            <a href="#" className="minimal_link_btn">
              Back to sign in
            </a>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="minimal_forgot">
      <div className="minimal_content">
        <div className="header_section">
          <h1 className="minimal_h1">Reset password</h1>
          <p className="minimal_description">
            Enter your email address and we'll send you a link to get back into your account.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="minimal_form_section">
          <div className={`minimal_input_wrapper ${isFocused || email ? 'active' : ''}`}>
            <label htmlFor="email" className="minimal_label">
              Email address
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              onFocus={() => setIsFocused(true)}
              onBlur={() => setIsFocused(false)}
              className="minimal_input"
              required
            />
            <div className="minimal_underline"></div>
          </div>

          <button
            type="submit"
            className="minimal_submit_btn"
            disabled={isLoading || !email}
          >
            {isLoading ? (
              <span className="loading_text">
                Sending<span className="dots"></span>
              </span>
            ) : (
              'Send recovery link'
            )}
          </button>
        </form>

        <div className="minimal_footer">
          <a href="#" className="back_to_login">
            ← Back to sign in
          </a>
        </div>
      </div>
    </div>
  );
};

export default ForgotPasswordScreen;
