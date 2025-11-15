import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  card: string;
  text: string;
}

interface CheckoutFlowProps {
  theme?: Partial<Theme>;
  onComplete?: (data: any) => void;
}

const defaultTheme: Theme = {
  primary: '#10b981',
  background: '#f9fafb',
  card: '#ffffff',
  text: '#111827'
};

export const CheckoutFlow: React.FC<CheckoutFlowProps> = ({
  theme = {},
  onComplete
}) => {
  const [step, setStep] = useState(1);
  const [data, setData] = useState({ shipping: '', payment: '', review: '' });
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
    maxWidth: '500px',
    width: '100%'
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
    marginTop: '1.5rem'
  };

  const handleNext = () => {
    if (step < 3) setStep(step + 1);
    else onComplete?.(data);
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <h2 style={{ fontSize: '1.875rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem' }}>
          Checkout - Step {step} of 3
        </h2>
        <p style={{ color: '#6b7280', marginBottom: '1.5rem' }}>
          {step === 1 && 'Enter shipping information'}
          {step === 2 && 'Enter payment details'}
          {step === 3 && 'Review your order'}
        </p>
        <button onClick={handleNext} style={buttonStyles}>
          {step === 3 ? 'Complete Order' : 'Continue'}
        </button>
      </div>
    </div>
  );
};
