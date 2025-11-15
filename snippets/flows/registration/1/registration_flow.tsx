import React, { useState } from 'react';

type Step = 'account' | 'profile' | 'preferences' | 'complete';

interface FormData {
  email: string;
  password: string;
  confirmPassword: string;
  firstName: string;
  lastName: string;
  bio: string;
  notifications: boolean;
  newsletter: boolean;
  theme: 'light' | 'dark';
}

export const RegistrationFlow: React.FC = () => {
  const [step, setStep] = useState<Step>('account');
  const [formData, setFormData] = useState<FormData>({
    email: '',
    password: '',
    confirmPassword: '',
    firstName: '',
    lastName: '',
    bio: '',
    notifications: true,
    newsletter: false,
    theme: 'light'
  });

  const steps: Step[] = ['account', 'profile', 'preferences', 'complete'];
  const currentIndex = steps.indexOf(step);

  const handleNext = () => {
    const nextIndex = currentIndex + 1;
    if (nextIndex < steps.length) {
      setStep(steps[nextIndex]);
    }
  };

  const handleBack = () => {
    const prevIndex = currentIndex - 1;
    if (prevIndex >= 0) {
      setStep(steps[prevIndex]);
    }
  };

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem 1rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1rem'
  };

  const renderStep = () => {
    switch (step) {
      case 'account':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Create Account</h2>
            <input
              type="email"
              placeholder="Email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              style={inputStyles}
            />
            <input
              type="password"
              placeholder="Password"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              style={inputStyles}
            />
            <input
              type="password"
              placeholder="Confirm Password"
              value={formData.confirmPassword}
              onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
              style={inputStyles}
            />
          </div>
        );

      case 'profile':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Profile Information</h2>
            <input
              type="text"
              placeholder="First Name"
              value={formData.firstName}
              onChange={(e) => setFormData({ ...formData, firstName: e.target.value })}
              style={inputStyles}
            />
            <input
              type="text"
              placeholder="Last Name"
              value={formData.lastName}
              onChange={(e) => setFormData({ ...formData, lastName: e.target.value })}
              style={inputStyles}
            />
            <textarea
              placeholder="Bio (optional)"
              value={formData.bio}
              onChange={(e) => setFormData({ ...formData, bio: e.target.value })}
              style={{ ...inputStyles, minHeight: '100px', resize: 'vertical' }}
            />
          </div>
        );

      case 'preferences':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Preferences</h2>
            <label style={{ display: 'flex', alignItems: 'center', marginBottom: '1rem', cursor: 'pointer' }}>
              <input
                type="checkbox"
                checked={formData.notifications}
                onChange={(e) => setFormData({ ...formData, notifications: e.target.checked })}
                style={{ marginRight: '0.75rem', width: '1.25rem', height: '1.25rem' }}
              />
              <span>Enable notifications</span>
            </label>
            <label style={{ display: 'flex', alignItems: 'center', marginBottom: '1.5rem', cursor: 'pointer' }}>
              <input
                type="checkbox"
                checked={formData.newsletter}
                onChange={(e) => setFormData({ ...formData, newsletter: e.target.checked })}
                style={{ marginRight: '0.75rem', width: '1.25rem', height: '1.25rem' }}
              />
              <span>Subscribe to newsletter</span>
            </label>
            <div style={{ marginBottom: '1rem' }}>
              <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 500 }}>Theme</label>
              <div style={{ display: 'flex', gap: '1rem' }}>
                <button
                  type="button"
                  onClick={() => setFormData({ ...formData, theme: 'light' })}
                  style={{
                    flex: 1,
                    padding: '0.75rem',
                    border: `2px solid ${formData.theme === 'light' ? '#3b82f6' : '#e5e7eb'}`,
                    borderRadius: '0.5rem',
                    backgroundColor: formData.theme === 'light' ? '#eff6ff' : '#fff',
                    cursor: 'pointer'
                  }}
                >
                  Light
                </button>
                <button
                  type="button"
                  onClick={() => setFormData({ ...formData, theme: 'dark' })}
                  style={{
                    flex: 1,
                    padding: '0.75rem',
                    border: `2px solid ${formData.theme === 'dark' ? '#3b82f6' : '#e5e7eb'}`,
                    borderRadius: '0.5rem',
                    backgroundColor: formData.theme === 'dark' ? '#eff6ff' : '#fff',
                    cursor: 'pointer'
                  }}
                >
                  Dark
                </button>
              </div>
            </div>
          </div>
        );

      case 'complete':
        return (
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '5rem', marginBottom: '1rem' }}>✅</div>
            <h2 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '0.5rem' }}>Welcome!</h2>
            <p style={{ color: '#6b7280', fontSize: '1.125rem' }}>
              Your account has been created successfully
            </p>
          </div>
        );
    }
  };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <div style={{ backgroundColor: '#fff', borderRadius: '1rem', padding: '2.5rem', maxWidth: '500px', width: '100%', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2rem' }}>
          {steps.slice(0, -1).map((s, i) => (
            <div key={s} style={{ flex: 1, textAlign: 'center' }}>
              <div style={{
                width: '2.5rem',
                height: '2.5rem',
                borderRadius: '50%',
                backgroundColor: i <= currentIndex ? '#3b82f6' : '#e5e7eb',
                color: '#fff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 0.5rem',
                fontWeight: 600
              }}>
                {i < currentIndex ? '✓' : i + 1}
              </div>
              <div style={{ fontSize: '0.75rem', textTransform: 'capitalize' }}>{s}</div>
            </div>
          ))}
        </div>

        {renderStep()}

        {step !== 'complete' && (
          <div style={{ display: 'flex', gap: '1rem', marginTop: '2rem' }}>
            {currentIndex > 0 && (
              <button
                onClick={handleBack}
                style={{
                  flex: 1,
                  padding: '0.875rem',
                  border: '2px solid #3b82f6',
                  borderRadius: '0.5rem',
                  backgroundColor: 'transparent',
                  color: '#3b82f6',
                  fontSize: '1rem',
                  fontWeight: 600,
                  cursor: 'pointer'
                }}
              >
                Back
              </button>
            )}
            <button
              onClick={handleNext}
              style={{
                flex: 1,
                padding: '0.875rem',
                backgroundColor: '#3b82f6',
                color: '#fff',
                border: 'none',
                borderRadius: '0.5rem',
                fontSize: '1rem',
                fontWeight: 600,
                cursor: 'pointer'
              }}
            >
              {currentIndex === steps.length - 2 ? 'Complete' : 'Next'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
