import React, { useState } from 'react';
import './auth_flow.css';

// Version 1: Traditional step-by-step authentication flow

type AuthStep = 'login' | 'signup' | 'forgot-password' | 'verify-email' | 'success';

interface AuthFlowProps {
  onComplete?: () => void;
}

export const AuthFlow: React.FC<AuthFlowProps> = ({ onComplete }) => {
  const [step, setStep] = useState<AuthStep>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [verificationCode, setVerificationCode] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    setStep('success');
  };

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    setStep('verify-email');
  };

  const handleForgotPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    setStep('verify-email');
  };

  const handleVerifyEmail = async (e: React.FormEvent) => {
    e.preventDefault();
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));
    setStep('success');
  };

  const renderLogin = () => (
    <div className="auth-step">
      <h2>Welcome Back</h2>
      <p className="subtitle">Sign in to your account</p>

      <form onSubmit={handleLogin} className="auth-form">
        <div className="form-field">
          <label>Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@example.com"
            required
          />
        </div>

        <div className="form-field">
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="••••••••"
            required
          />
        </div>

        <button type="button" className="link-btn" onClick={() => setStep('forgot-password')}>
          Forgot password?
        </button>

        <button type="submit" className="primary-btn">
          Sign In
        </button>

        <div className="divider">
          <span>or</span>
        </div>

        <button type="button" className="secondary-btn" onClick={() => setStep('signup')}>
          Create new account
        </button>
      </form>
    </div>
  );

  const renderSignup = () => (
    <div className="auth-step">
      <h2>Create Account</h2>
      <p className="subtitle">Join us today</p>

      <form onSubmit={handleSignup} className="auth-form">
        <div className="form-field">
          <label>Full Name</label>
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="John Doe"
            required
          />
        </div>

        <div className="form-field">
          <label>Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@example.com"
            required
          />
        </div>

        <div className="form-field">
          <label>Password</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="••••••••"
            required
          />
        </div>

        <button type="submit" className="primary-btn">
          Create Account
        </button>

        <button type="button" className="link-btn" onClick={() => setStep('login')}>
          Already have an account? Sign in
        </button>
      </form>
    </div>
  );

  const renderForgotPassword = () => (
    <div className="auth-step">
      <h2>Reset Password</h2>
      <p className="subtitle">We'll send you a reset link</p>

      <form onSubmit={handleForgotPassword} className="auth-form">
        <div className="form-field">
          <label>Email</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="you@example.com"
            required
          />
        </div>

        <button type="submit" className="primary-btn">
          Send Reset Link
        </button>

        <button type="button" className="link-btn" onClick={() => setStep('login')}>
          Back to login
        </button>
      </form>
    </div>
  );

  const renderVerifyEmail = () => (
    <div className="auth-step">
      <div className="icon-circle">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
      </div>
      <h2>Verify Your Email</h2>
      <p className="subtitle">We sent a code to {email}</p>

      <form onSubmit={handleVerifyEmail} className="auth-form">
        <div className="form-field">
          <label>Verification Code</label>
          <input
            type="text"
            value={verificationCode}
            onChange={(e) => setVerificationCode(e.target.value)}
            placeholder="000000"
            maxLength={6}
            required
          />
        </div>

        <button type="submit" className="primary-btn">
          Verify
        </button>

        <button type="button" className="link-btn">
          Resend code
        </button>
      </form>
    </div>
  );

  const renderSuccess = () => (
    <div className="auth-step success">
      <div className="icon-circle success">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
        </svg>
      </div>
      <h2>All Set!</h2>
      <p className="subtitle">You're successfully logged in</p>

      <button onClick={onComplete} className="primary-btn">
        Continue
      </button>
    </div>
  );

  return (
    <div className="auth-flow-container">
      <div className="auth-flow-card">
        {step === 'login' && renderLogin()}
        {step === 'signup' && renderSignup()}
        {step === 'forgot-password' && renderForgotPassword()}
        {step === 'verify-email' && renderVerifyEmail()}
        {step === 'success' && renderSuccess()}
      </div>
    </div>
  );
};
