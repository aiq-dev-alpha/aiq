import React, { useState } from 'react';
import './signup_screen.css';

// Version 2: Multi-step wizard with progress indicator

type Step = 1 | 2 | 3;

interface FormData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  confirmPassword: string;
  acceptTerms: boolean;
}

export const SignupScreen: React.FC = () => {
  const [currentStep, setCurrentStep] = useState<Step>(1);
  const [formData, setFormData] = useState<FormData>({
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    confirmPassword: '',
    acceptTerms: false
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [showPassword, setShowPassword] = useState(false);

  const steps = ['Personal Info', 'Account Details', 'Confirmation'];

  const validateStep = (): boolean => {
    const newErrors: Record<string, string> = {};

    if (currentStep === 1) {
      if (!formData.firstName.trim()) newErrors.firstName = 'First name required';
      if (!formData.lastName.trim()) newErrors.lastName = 'Last name required';
    }

    if (currentStep === 2) {
      if (!formData.email.trim()) newErrors.email = 'Email required';
      else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
        newErrors.email = 'Invalid email';
      }
      if (!formData.password) newErrors.password = 'Password required';
      else if (formData.password.length < 8) newErrors.password = 'Min 8 characters';
      if (formData.password !== formData.confirmPassword) {
        newErrors.confirmPassword = 'Passwords must match';
      }
    }

    if (currentStep === 3) {
      if (!formData.acceptTerms) newErrors.acceptTerms = 'Must accept terms';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const nextStep = () => {
    if (validateStep() && currentStep < 3) {
      setCurrentStep((currentStep + 1) as Step);
    }
  };

  const prevStep = () => {
    if (currentStep > 1) {
      setCurrentStep((currentStep - 1) as Step);
      setErrors({});
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (validateStep()) {
      console.log('Creating account...', formData);
      // API call here
    }
  };

  const updateField = (field: keyof FormData, value: string | boolean) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  return (
    <div className="wizard-signup-container">
      <div className="wizard-card">
        {/* Progress Indicator */}
        <div className="progress-bar-container">
          {steps.map((step, index) => (
            <div key={index} className="progress-step">
              <div className={`step-circle ${currentStep > index ? 'completed' : currentStep === index + 1 ? 'active' : ''}`}>
                {currentStep > index + 1 ? (
                  <svg viewBox="0 0 20 20" fill="currentColor">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                ) : (
                  index + 1
                )}
              </div>
              <div className="step-label">{step}</div>
              {index < steps.length - 1 && <div className={`step-line ${currentStep > index + 1 ? 'completed' : ''}`} />}
            </div>
          ))}
        </div>

        <form onSubmit={handleSubmit} className="wizard-form">
          {/* Step 1: Personal Info */}
          {currentStep === 1 && (
            <div className="step-content">
              <h2>Let's get to know you</h2>
              <p className="step-subtitle">Tell us your name to personalize your experience</p>

              <div className="form-row">
                <div className="form-field">
                  <label>First Name</label>
                  <input
                    type="text"
                    value={formData.firstName}
                    onChange={(e) => updateField('firstName', e.target.value)}
                    placeholder="John"
                    className={errors.firstName ? 'error' : ''}
                  />
                  {errors.firstName && <span className="error-text">{errors.firstName}</span>}
                </div>

                <div className="form-field">
                  <label>Last Name</label>
                  <input
                    type="text"
                    value={formData.lastName}
                    onChange={(e) => updateField('lastName', e.target.value)}
                    placeholder="Doe"
                    className={errors.lastName ? 'error' : ''}
                  />
                  {errors.lastName && <span className="error-text">{errors.lastName}</span>}
                </div>
              </div>
            </div>
          )}

          {/* Step 2: Account Details */}
          {currentStep === 2 && (
            <div className="step-content">
              <h2>Create your account</h2>
              <p className="step-subtitle">Choose your login credentials</p>

              <div className="form-field">
                <label>Email Address</label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => updateField('email', e.target.value)}
                  placeholder="john.doe@example.com"
                  className={errors.email ? 'error' : ''}
                />
                {errors.email && <span className="error-text">{errors.email}</span>}
              </div>

              <div className="form-field">
                <label>Password</label>
                <div className="password-input">
                  <input
                    type={showPassword ? 'text' : 'password'}
                    value={formData.password}
                    onChange={(e) => updateField('password', e.target.value)}
                    placeholder="••••••••"
                    className={errors.password ? 'error' : ''}
                  />
                  <button
                    type="button"
                    className="toggle-password"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? '👁️' : '👁️‍🗨️'}
                  </button>
                </div>
                {errors.password && <span className="error-text">{errors.password}</span>}
              </div>

              <div className="form-field">
                <label>Confirm Password</label>
                <input
                  type="password"
                  value={formData.confirmPassword}
                  onChange={(e) => updateField('confirmPassword', e.target.value)}
                  placeholder="••••••••"
                  className={errors.confirmPassword ? 'error' : ''}
                />
                {errors.confirmPassword && <span className="error-text">{errors.confirmPassword}</span>}
              </div>
            </div>
          )}

          {/* Step 3: Confirmation */}
          {currentStep === 3 && (
            <div className="step-content confirmation">
              <div className="success-icon">✓</div>
              <h2>You're almost there!</h2>
              <p className="step-subtitle">Review your information and accept our terms</p>

              <div className="info-review">
                <div className="review-item">
                  <span className="review-label">Name:</span>
                  <span className="review-value">{formData.firstName} {formData.lastName}</span>
                </div>
                <div className="review-item">
                  <span className="review-label">Email:</span>
                  <span className="review-value">{formData.email}</span>
                </div>
              </div>

              <label className="checkbox-label">
                <input
                  type="checkbox"
                  checked={formData.acceptTerms}
                  onChange={(e) => updateField('acceptTerms', e.target.checked)}
                />
                <span>
                  I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                </span>
              </label>
              {errors.acceptTerms && <span className="error-text">{errors.acceptTerms}</span>}
            </div>
          )}

          {/* Navigation Buttons */}
          <div className="wizard-actions">
            {currentStep > 1 && (
              <button type="button" onClick={prevStep} className="btn-secondary">
                Back
              </button>
            )}
            {currentStep < 3 ? (
              <button type="button" onClick={nextStep} className="btn-primary">
                Continue
              </button>
            ) : (
              <button type="submit" className="btn-primary">
                Create Account
              </button>
            )}
          </div>
        </form>

        <div className="signin-link">
          Already have an account? <a href="#">Sign in</a>
        </div>
      </div>
    </div>
  );
};

export default SignupScreen;
