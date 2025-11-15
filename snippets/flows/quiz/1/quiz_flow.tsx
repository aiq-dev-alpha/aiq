import React, { useState } from 'react';

interface QuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
}

const questions: QuizQuestion[] = [
  {
    id: '1',
    question: 'What is the capital of France?',
    options: ['London', 'Berlin', 'Paris', 'Madrid'],
    correctAnswer: 2
  },
  {
    id: '2',
    question: 'Which planet is closest to the Sun?',
    options: ['Venus', 'Mercury', 'Earth', 'Mars'],
    correctAnswer: 1
  },
  {
    id: '3',
    question: 'What is 2 + 2?',
    options: ['3', '4', '5', '6'],
    correctAnswer: 1
  }
];

export const QuizFlow: React.FC = () => {
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [score, setScore] = useState(0);
  const [showResult, setShowResult] = useState(false);
  const [answers, setAnswers] = useState<(number | null)[]>(new Array(questions.length).fill(null));

  const question = questions[currentQuestion];

  const handleNext = () => {
    if (selectedAnswer === question.correctAnswer) {
      setScore(score + 1);
    }

    const newAnswers = [...answers];
    newAnswers[currentQuestion] = selectedAnswer;
    setAnswers(newAnswers);

    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1);
      setSelectedAnswer(null);
    } else {
      setShowResult(true);
    }
  };

  if (showResult) {
    return (
      <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
        <div style={{ backgroundColor: '#fff', borderRadius: '1rem', padding: '3rem', maxWidth: '500px', textAlign: 'center', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
          <div style={{ fontSize: '5rem', marginBottom: '1rem' }}>
            {score === questions.length ? '🎉' : score >= questions.length / 2 ? '👍' : '📚'}
          </div>
          <h2 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '0.5rem' }}>Quiz Complete!</h2>
          <p style={{ fontSize: '1.5rem', color: '#6b7280', marginBottom: '2rem' }}>
            You scored {score} out of {questions.length}
          </p>
          <div style={{ fontSize: '3rem', fontWeight: 700, color: '#3b82f6', marginBottom: '2rem' }}>
            {Math.round((score / questions.length) * 100)}%
          </div>
          <button
            onClick={() => window.location.reload()}
            style={{
              padding: '0.875rem 2rem',
              backgroundColor: '#3b82f6',
              color: '#fff',
              border: 'none',
              borderRadius: '0.5rem',
              fontSize: '1rem',
              fontWeight: 600,
              cursor: 'pointer'
            }}
          >
            Retry Quiz
          </button>
        </div>
      </div>
    );
  }

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <div style={{ backgroundColor: '#fff', borderRadius: '1rem', padding: '2.5rem', maxWidth: '600px', width: '100%', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
        <div style={{ marginBottom: '2rem' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
            <span style={{ fontSize: '0.875rem', color: '#6b7280' }}>
              Question {currentQuestion + 1} of {questions.length}
            </span>
            <span style={{ fontSize: '0.875rem', color: '#6b7280' }}>
              Score: {score}
            </span>
          </div>
          <div style={{ width: '100%', height: '0.5rem', backgroundColor: '#e5e7eb', borderRadius: '9999px', overflow: 'hidden' }}>
            <div style={{ width: `${((currentQuestion + 1) / questions.length) * 100}%`, height: '100%', backgroundColor: '#3b82f6', transition: 'width 0.3s' }} />
          </div>
        </div>

        <h2 style={{ fontSize: '1.5rem', fontWeight: 600, marginBottom: '2rem' }}>{question.question}</h2>

        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', marginBottom: '2rem' }}>
          {question.options.map((option, index) => (
            <button
              key={index}
              onClick={() => setSelectedAnswer(index)}
              style={{
                padding: '1rem 1.25rem',
                border: `2px solid ${selectedAnswer === index ? '#3b82f6' : '#e5e7eb'}`,
                borderRadius: '0.5rem',
                backgroundColor: selectedAnswer === index ? '#eff6ff' : '#fff',
                color: selectedAnswer === index ? '#3b82f6' : '#374151',
                fontSize: '1rem',
                textAlign: 'left',
                cursor: 'pointer',
                transition: 'all 0.2s'
              }}
            >
              {option}
            </button>
          ))}
        </div>

        <button
          onClick={handleNext}
          disabled={selectedAnswer === null}
          style={{
            width: '100%',
            padding: '0.875rem',
            backgroundColor: selectedAnswer !== null ? '#3b82f6' : '#d1d5db',
            color: '#fff',
            border: 'none',
            borderRadius: '0.5rem',
            fontSize: '1rem',
            fontWeight: 600,
            cursor: selectedAnswer !== null ? 'pointer' : 'not-allowed'
          }}
        >
          {currentQuestion === questions.length - 1 ? 'Finish' : 'Next Question'}
        </button>
      </div>
    </div>
  );
};
