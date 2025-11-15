import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  card: string;
  text: string;
}

interface SignupFlowProps {
  theme?: Partial<Theme>;
  onComplete?: (data: any) => void;
}

const defaultTheme: Theme = {
  primary: '#6366f1',
  background: '#f9fafb',
  card: '#ffffff',
  text: '#111827'
};

export const SignupFlow: React.FC<SignupFlowProps> = ({
  theme = {},
  onComplete
}) => {
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({ email: '', password: '', name: '' });
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.background,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.card,
    padding: '2.5rem',
    borderRadius: '1rem',
    boxShadow: '0 10px 25px rgba(0, 0, 0, 0.1)',
    maxWidth: '450px',
    width: '100%'
  };

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1rem'
  };

  const buttonStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.875rem',
    backgroundColor: appliedTheme.primary,
    color: '#ffffff',
    border: 'none',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer',
    marginTop: '1rem'
  };

  const handleNext = () => {
    if (step < 3) setStep(step + 1);
    else onComplete?.(formData);
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <h2 style={{ fontSize: '1.75rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem' }}>Sign Up - Step {step}/3</h2>
        {step === 1 && (
          <input
            type="email"
            placeholder="Email"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
            style={inputStyles}
          />
        )}
        {step === 2 && (
          <input
            type="password"
            placeholder="Password"
            value={formData.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
            style={inputStyles}
          />
        )}
        {step === 3 && (
          <input
            type="text"
            placeholder="Name"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            style={inputStyles}
          />
        )}
        <button onClick={handleNext} style={buttonStyles}>{step === 3 ? 'Complete' : 'Next'}</button>
      </div>
    </div>
  );
};
