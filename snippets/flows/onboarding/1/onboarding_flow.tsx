import React, { useState } from 'react';

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  cardBackground: string;
}

interface OnboardingStep {
  id: string;
  title: string;
  description: string;
  icon: string;
}

interface OnboardingFlowProps {
  steps?: OnboardingStep[];
  onComplete?: () => void;
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#f9fafb',
  textColor: '#111827',
  cardBackground: '#ffffff'
};

const defaultSteps: OnboardingStep[] = [
  {
    id: '1',
    title: 'Welcome',
    description: 'Welcome to our platform! Let us show you around.',
    icon: '👋'
  },
  {
    id: '2',
    title: 'Features',
    description: 'Discover all the amazing features we have to offer.',
    icon: '✨'
  },
  {
    id: '3',
    title: 'Get Started',
    description: 'You\'re all set! Let\'s begin your journey.',
    icon: '🚀'
  }
];

export const OnboardingFlow: React.FC<OnboardingFlowProps> = ({
  steps = defaultSteps,
  onComplete,
  theme = {}
}) => {
  const [currentStep, setCurrentStep] = useState(0);
  const appliedTheme = { ...defaultTheme, ...theme };

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      onComplete?.();
    }
  };

  const handlePrevious = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSkip = () => {
    onComplete?.();
  };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    borderRadius: '1rem',
    padding: '3rem',
    maxWidth: '600px',
    width: '100%',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)',
    textAlign: 'center'
  };

  const iconStyles: React.CSSProperties = {
    fontSize: '5rem',
    marginBottom: '2rem'
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '2rem',
    fontWeight: 700,
    color: appliedTheme.textColor,
    marginBottom: '1rem'
  };

  const descriptionStyles: React.CSSProperties = {
    fontSize: '1.125rem',
    color: '#6b7280',
    marginBottom: '3rem',
    lineHeight: 1.6
  };

  const progressContainerStyles: React.CSSProperties = {
    display: 'flex',
    gap: '0.5rem',
    justifyContent: 'center',
    marginBottom: '2rem'
  };

  const progressDotStyles = (isActive: boolean): React.CSSProperties => ({
    width: isActive ? '2rem' : '0.5rem',
    height: '0.5rem',
    borderRadius: '9999px',
    backgroundColor: isActive ? appliedTheme.primaryColor : '#d1d5db',
    transition: 'all 0.3s'
  });

  const buttonContainerStyles: React.CSSProperties = {
    display: 'flex',
    gap: '1rem',
    justifyContent: 'space-between',
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
    cursor: 'pointer',
    transition: 'all 0.2s'
  });

  const skipButtonStyles: React.CSSProperties = {
    position: 'absolute',
    top: '2rem',
    right: '2rem',
    background: 'none',
    border: 'none',
    color: '#6b7280',
    fontSize: '1rem',
    cursor: 'pointer'
  };

  const currentStepData = steps[currentStep];

  return (
    <div style={containerStyles}>
      <button style={skipButtonStyles} onClick={handleSkip}>
        Skip
      </button>

      <div style={cardStyles}>
        <div style={iconStyles}>{currentStepData.icon}</div>

        <div style={progressContainerStyles}>
          {steps.map((_, index) => (
            <div key={index} style={progressDotStyles(index === currentStep)} />
          ))}
        </div>

        <h1 style={titleStyles}>{currentStepData.title}</h1>
        <p style={descriptionStyles}>{currentStepData.description}</p>

        <div style={buttonContainerStyles}>
          <button
            style={buttonStyles(false)}
            onClick={handlePrevious}
            disabled={currentStep === 0}
          >
            Previous
          </button>

          <button style={buttonStyles(true)} onClick={handleNext}>
            {currentStep === steps.length - 1 ? 'Get Started' : 'Next'}
          </button>
        </div>
      </div>
    </div>
  );
};
