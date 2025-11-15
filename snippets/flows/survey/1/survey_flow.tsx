import React, { useState } from 'react';

interface Question {
  id: string;
  text: string;
  type: 'text' | 'radio' | 'checkbox' | 'rating';
  options?: string[];
}

interface Theme {
  primaryColor: string;
  backgroundColor: string;
  textColor: string;
  cardBackground: string;
}

interface SurveyFlowProps {
  questions?: Question[];
  onComplete?: (answers: Record<string, any>) => void;
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  primaryColor: '#3b82f6',
  backgroundColor: '#f9fafb',
  textColor: '#111827',
  cardBackground: '#ffffff'
};

const defaultQuestions: Question[] = [
  {
    id: '1',
    text: 'How satisfied are you with our service?',
    type: 'rating'
  },
  {
    id: '2',
    text: 'What do you like most about our product?',
    type: 'checkbox',
    options: ['Easy to use', 'Great design', 'Fast performance', 'Good support']
  },
  {
    id: '3',
    text: 'Any additional feedback?',
    type: 'text'
  }
];

export const SurveyFlow: React.FC<SurveyFlowProps> = ({
  questions = defaultQuestions,
  onComplete,
  theme = {}
}) => {
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [answers, setAnswers] = useState<Record<string, any>>({});
  const [isComplete, setIsComplete] = useState(false);

  const appliedTheme = { ...defaultTheme, ...theme };
  const question = questions[currentQuestion];
  const progress = ((currentQuestion + 1) / questions.length) * 100;

  const handleAnswer = (value: any) => {
    setAnswers({ ...answers, [question.id]: value });
  };

  const handleNext = () => {
    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1);
    } else {
      setIsComplete(true);
      onComplete?.(answers);
    }
  };

  const handleBack = () => {
    if (currentQuestion > 0) {
      setCurrentQuestion(currentQuestion - 1);
    }
  };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    borderRadius: '1rem',
    padding: '2.5rem',
    maxWidth: '600px',
    width: '100%',
    boxShadow: '0 4px 6px rgba(0, 0, 0, 0.1)'
  };

  const progressBarStyles: React.CSSProperties = {
    width: '100%',
    height: '0.5rem',
    backgroundColor: '#e5e7eb',
    borderRadius: '9999px',
    overflow: 'hidden',
    marginBottom: '2rem'
  };

  const progressFillStyles: React.CSSProperties = {
    height: '100%',
    width: `${progress}%`,
    backgroundColor: appliedTheme.primaryColor,
    transition: 'width 0.3s'
  };

  const questionStyles: React.CSSProperties = {
    fontSize: '1.5rem',
    fontWeight: 600,
    color: appliedTheme.textColor,
    marginBottom: '2rem'
  };

  const inputStyles: React.CSSProperties = {
    width: '100%',
    padding: '0.75rem 1rem',
    border: '1px solid #d1d5db',
    borderRadius: '0.5rem',
    fontSize: '1rem',
    marginBottom: '1.5rem',
    fontFamily: 'inherit'
  };

  const optionStyles = (isSelected: boolean): React.CSSProperties => ({
    padding: '0.875rem 1.25rem',
    border: `2px solid ${isSelected ? appliedTheme.primaryColor : '#d1d5db'}`,
    borderRadius: '0.5rem',
    marginBottom: '0.75rem',
    cursor: 'pointer',
    backgroundColor: isSelected ? `${appliedTheme.primaryColor}10` : 'transparent',
    transition: 'all 0.2s'
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
    cursor: 'pointer'
  });

  if (isComplete) {
    return (
      <div style={containerStyles}>
        <div style={{ ...cardStyles, textAlign: 'center' }}>
          <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>🎉</div>
          <h2 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '0.5rem' }}>Thank You!</h2>
          <p style={{ fontSize: '1.125rem', color: '#6b7280' }}>
            Your feedback has been submitted successfully.
          </p>
        </div>
      </div>
    );
  }

  const renderQuestion = () => {
    switch (question.type) {
      case 'text':
        return (
          <textarea
            value={answers[question.id] || ''}
            onChange={(e) => handleAnswer(e.target.value)}
            style={{ ...inputStyles, minHeight: '120px', resize: 'vertical' }}
            placeholder="Type your answer here..."
          />
        );

      case 'radio':
        return (
          <div>
            {question.options?.map((option) => (
              <div
                key={option}
                style={optionStyles(answers[question.id] === option)}
                onClick={() => handleAnswer(option)}
              >
                {option}
              </div>
            ))}
          </div>
        );

      case 'checkbox':
        return (
          <div>
            {question.options?.map((option) => {
              const selected = answers[question.id] || [];
              const isSelected = selected.includes(option);
              return (
                <div
                  key={option}
                  style={optionStyles(isSelected)}
                  onClick={() => {
                    const newSelected = isSelected
                      ? selected.filter((s: string) => s !== option)
                      : [...selected, option];
                    handleAnswer(newSelected);
                  }}
                >
                  {option}
                </div>
              );
            })}
          </div>
        );

      case 'rating':
        return (
          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
            {[1, 2, 3, 4, 5].map((rating) => (
              <button
                key={rating}
                onClick={() => handleAnswer(rating)}
                style={{
                  width: '3.5rem',
                  height: '3.5rem',
                  borderRadius: '50%',
                  border: `2px solid ${answers[question.id] === rating ? appliedTheme.primaryColor : '#d1d5db'}`,
                  backgroundColor: answers[question.id] === rating ? appliedTheme.primaryColor : 'transparent',
                  color: answers[question.id] === rating ? '#ffffff' : appliedTheme.textColor,
                  fontSize: '1.25rem',
                  fontWeight: 600,
                  cursor: 'pointer',
                  transition: 'all 0.2s'
                }}
              >
                {rating}
              </button>
            ))}
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div style={containerStyles}>
      <div style={cardStyles}>
        <div style={progressBarStyles}>
          <div style={progressFillStyles} />
        </div>

        <div style={{ fontSize: '0.875rem', color: '#6b7280', marginBottom: '0.5rem' }}>
          Question {currentQuestion + 1} of {questions.length}
        </div>

        <h2 style={questionStyles}>{question.text}</h2>

        {renderQuestion()}

        <div style={buttonContainerStyles}>
          <button
            style={buttonStyles(false)}
            onClick={handleBack}
            disabled={currentQuestion === 0}
          >
            Back
          </button>

          <button
            style={buttonStyles(true)}
            onClick={handleNext}
            disabled={!answers[question.id]}
          >
            {currentQuestion === questions.length - 1 ? 'Submit' : 'Next'}
          </button>
        </div>
      </div>
    </div>
  );
};
