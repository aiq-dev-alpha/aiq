import React, { useState } from 'react';

type CheckoutStep = 'cart' | 'shipping' | 'payment' | 'confirmation';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  cardBackground: string;
}

interface CheckoutFlowProps {
  onComplete?: (data: any) => void;
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#f9fafb',
  textColor: '#111827',
  cardBackground: '#ffffff'
};

export const CheckoutFlow: React.FC<CheckoutFlowProps> = ({
  onComplete,
  theme = {}
}) => {
  const [step, setStep] = useState<CheckoutStep>('cart');
  const [formData, setFormData] = useState({
    email: '',
    address: '',
    city: '',
    cardNumber: '',
    expiry: '',
    cvv: ''
  });

  const appliedTheme = { ...defaultTheme, ...theme };

  const steps: CheckoutStep[] = ['cart', 'shipping', 'payment', 'confirmation'];
  const currentStepIndex = steps.indexOf(step);

  const handleNext = () => {
    const nextIndex = currentStepIndex + 1;
    if (nextIndex < steps.length) {
      setStep(steps[nextIndex]);
    } else {
      onComplete?.(formData);
    }
  };

  const handleBack = () => {
    const prevIndex = currentStepIndex - 1;
    if (prevIndex >= 0) {
      setStep(steps[prevIndex]);
    }
  };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    maxWidth: '800px',
    margin: '0 auto',
    backgroundColor: appliedTheme.cardBackground,
    borderRadius: '1rem',
    padding: '2rem',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
  };

  const stepperStyles: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: '2rem',
    position: 'relative'
  };

  const stepStyles = (isActive: boolean, isCompleted: boolean): React.CSSProperties => ({
    flex: 1,
    textAlign: 'center',
    position: 'relative'
  });

  const stepCircleStyles = (isActive: boolean, isCompleted: boolean): React.CSSProperties => ({
    width: '3rem',
    height: '3rem',
    borderRadius: '50%',
    backgroundColor: isCompleted || isActive ? appliedTheme.primaryColor : '#e5e7eb',
    color: '#ffffff',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    margin: '0 auto 0.5rem',
    fontWeight: 600
  });

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem 1rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1rem'
  };

  const buttonContainerStyles: React.CSSProperties = {
    display: 'flex',
    gap: '1rem',
    justifyContent: 'flex-end',
    marginTop: '2rem'
  };

  const buttonStyles = (isPrimary: boolean): React.CSSProperties => ({
    padding: '0.75rem 2rem',
    borderRadius: '0.5rem',
    border: isPrimary ? 'none' : `2px solid ${appliedTheme.primaryColor}`,
    backgroundColor: isPrimary ? appliedTheme.primaryColor : 'transparent',
    color: isPrimary ? '#ffffff' : appliedTheme.primaryColor,
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer'
  });

  const renderStep = () => {
    switch (step) {
      case 'cart':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Shopping Cart</h2>
            <div style={{ padding: '1rem', backgroundColor: '#f9fafb', borderRadius: '0.5rem', marginBottom: '1rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                <span>Product Name</span>
                <span style={{ fontWeight: 600 }}>$99.99</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>Subtotal</span>
                <span style={{ fontWeight: 700, fontSize: '1.125rem' }}>$99.99</span>
              </div>
            </div>
          </div>
        );

      case 'shipping':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Shipping Information</h2>
            <input
              type="email"
              placeholder="Email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              style={inputStyles}
            />
            <input
              type="text"
              placeholder="Address"
              value={formData.address}
              onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              style={inputStyles}
            />
            <input
              type="text"
              placeholder="City"
              value={formData.city}
              onChange={(e) => setFormData({ ...formData, city: e.target.value })}
              style={inputStyles}
            />
          </div>
        );

      case 'payment':
        return (
          <div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1rem' }}>Payment Details</h2>
            <input
              type="text"
              placeholder="Card Number"
              value={formData.cardNumber}
              onChange={(e) => setFormData({ ...formData, cardNumber: e.target.value })}
              style={inputStyles}
            />
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <input
                type="text"
                placeholder="MM/YY"
                value={formData.expiry}
                onChange={(e) => setFormData({ ...formData, expiry: e.target.value })}
                style={inputStyles}
              />
              <input
                type="text"
                placeholder="CVV"
                value={formData.cvv}
                onChange={(e) => setFormData({ ...formData, cvv: e.target.value })}
                style={inputStyles}
              />
            </div>
          </div>
        );

      case 'confirmation':
        return (
          <div style={{ textAlign: 'center', padding: '2rem' }}>
            <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>✅</div>
            <h2 style={{ fontSize: '1.875rem', fontWeight: 700, marginBottom: '0.5rem' }}>Order Confirmed!</h2>
            <p style={{ color: '#6b7280' }}>Your order has been placed successfully.</p>
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <div style={stepperStyles}>
          {steps.map((s, index) => (
            <div key={s} style={stepStyles(s === step, index < currentStepIndex)}>
              <div style={stepCircleStyles(s === step, index < currentStepIndex)}>
                {index < currentStepIndex ? '✓' : index + 1}
              </div>
              <div style={{ fontSize: '0.875rem', textTransform: 'capitalize' }}>{s}</div>
            </div>
          ))}
        </div>

        {renderStep()}

        {step !== 'confirmation' && (
          <div style={buttonContainerStyles}>
            {currentStepIndex > 0 && (
              <button style={buttonStyles(false)} onClick={handleBack}>
                Back
              </button>
            )}
            <button style={buttonStyles(true)} onClick={handleNext}>
              {currentStepIndex === steps.length - 2 ? 'Complete Order' : 'Continue'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
