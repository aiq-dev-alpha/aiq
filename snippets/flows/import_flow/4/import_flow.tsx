import React, { useState } from 'react';

interface Theme {
  primary: string;
  secondary: string;
  background: string;
  card: string;
  text: string;
  border: string;
}

interface FlowProps {
  theme?: Partial<Theme>;
  onComplete?: (data: any) => void;
  totalSteps?: number;
}

const defaultTheme: Theme = {
  primary: '#8b5cf6',
  secondary: '#a78bfa',
  background: '#f3f4f6',
  card: '#ffffff',
  text: '#1f2937',
  border: '#e5e7eb'
};

export const Flow: React.FC<FlowProps> = ({ 
  theme = {}, 
  onComplete,
  totalSteps = 4
}) => {
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState({});
  const appliedTheme = { ...defaultTheme, ...theme };

  const handleNext = () => {
    if (currentStep < totalSteps) {
      setCurrentStep(currentStep + 1);
    } else {
      onComplete?.(formData);
    }
  };

  const handlePrevious = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    }
  };

  const progressPercentage = (currentStep / totalSteps) * 100;

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
    maxWidth: '600px',
    width: '100%'
  };

  const progressBarStyles: React.CSSProperties = {
    width: '100%',
    height: '4px',
    backgroundColor: appliedTheme.border,
    borderRadius: '2px',
    marginBottom: '2rem',
    overflow: 'hidden'
  };

  const progressFillStyles: React.CSSProperties = {
    width: `${progressPercentage}%`,
    height: '100%',
    backgroundColor: appliedTheme.primary,
    transition: 'width 0.3s ease'
  };

  const buttonContainerStyles: React.CSSProperties = {
    display: 'flex',
    gap: '1rem',
    marginTop: '2rem'
  };

  const buttonStyles: React.CSSProperties = {
    flex: 1,
    padding: '0.875rem',
    backgroundColor: appliedTheme.primary,
    color: '#ffffff',
    border: 'none',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    fontWeight: 600,
    cursor: 'pointer'
  };

  const secondaryButtonStyles: React.CSSProperties = {
    ...buttonStyles,
    backgroundColor: 'transparent',
    color: appliedTheme.primary,
    border: `2px solid ${appliedTheme.primary}`
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <div style={progressBarStyles}>
          <div style={progressFillStyles} />
        </div>
        <h2 style={{ fontSize: '1.875rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '0.5rem' }}>
          Step {currentStep} of {totalSteps}
        </h2>
        <p style={{ color: '#6b7280', marginBottom: '2rem' }}>
          Complete this step to continue
        </p>
        <div style={buttonContainerStyles}>
          {currentStep > 1 && (
            <button onClick={handlePrevious} style={secondaryButtonStyles}>
              Previous
            </button>
          )}
          <button onClick={handleNext} style={buttonStyles}>
            {currentStep === totalSteps ? 'Complete' : 'Next'}
          </button>
        </div>
      </div>
    </div>
  );
};
