import React, { useState } from 'react';
import './signup_screen.css';

// Version 3: Minimal, clean single-column design

interface FormData {
  name: string;
  email: string;
  password: string;
}

export const SignupScreen: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    email: '',
    password: ''
  });
  const [isLoading, setIsLoading] = useState(false);
  const [focusedField, setFocusedField] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1500));
    console.log('Account created:', formData);
    setIsLoading(false);
  };

  const updateField = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  return (
    <div className="minimal-signup">
      <div className="minimal-container">
        <div className="minimal-header">
          <h1>Create Account</h1>
          <p>Join thousands of users worldwide</p>
        </div>

        <form onSubmit={handleSubmit} className="minimal-form">
          <div className={`minimal-field ${focusedField === 'name' ? 'focused' : ''} ${formData.name ? 'filled' : ''}`}>
            <input
              type="text"
              id="name"
              value={formData.name}
              onChange={(e) => updateField('name', e.target.value)}
              onFocus={() => setFocusedField('name')}
              onBlur={() => setFocusedField(null)}
              required
            />
            <label htmlFor="name">Full Name</label>
            <div className="field-line" />
          </div>

          <div className={`minimal-field ${focusedField === 'email' ? 'focused' : ''} ${formData.email ? 'filled' : ''}`}>
            <input
              type="email"
              id="email"
              value={formData.email}
              onChange={(e) => updateField('email', e.target.value)}
              onFocus={() => setFocusedField('email')}
              onBlur={() => setFocusedField(null)}
              required
            />
            <label htmlFor="email">Email Address</label>
            <div className="field-line" />
          </div>

          <div className={`minimal-field ${focusedField === 'password' ? 'focused' : ''} ${formData.password ? 'filled' : ''}`}>
            <input
              type="password"
              id="password"
              value={formData.password}
              onChange={(e) => updateField('password', e.target.value)}
              onFocus={() => setFocusedField('password')}
              onBlur={() => setFocusedField(null)}
              required
            />
            <label htmlFor="password">Password</label>
            <div className="field-line" />
          </div>

          <button type="submit" className="minimal-submit" disabled={isLoading}>
            {isLoading ? (
              <span className="loading-dots">
                <span>.</span><span>.</span><span>.</span>
              </span>
            ) : (
              'Sign Up'
            )}
          </button>

          <div className="minimal-terms">
            By signing up, you agree to our{' '}
            <a href="#">Terms</a> & <a href="#">Privacy Policy</a>
          </div>
        </form>

        <div className="minimal-footer">
          <span>Already have an account?</span>
          <a href="#">Sign In</a>
        </div>
      </div>

      <div className="minimal-aside">
        <div className="quote-mark">"</div>
        <blockquote>
          <p>The best platform I've used. Clean, simple, and effective.</p>
          <footer>
            <strong>Sarah Johnson</strong>
            <span>Product Designer</span>
          </footer>
        </blockquote>
      </div>
    </div>
  );
};

export default SignupScreen;
