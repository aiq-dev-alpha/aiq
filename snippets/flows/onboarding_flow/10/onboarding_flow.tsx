import React, { useState } from 'react';

interface Theme {
  primary: string;
  background: string;
  card: string;
  text: string;
}

interface FlowProps {
  theme?: Partial<Theme>;
  onComplete?: (data: any) => void;
}

const defaultTheme: Theme = {
  primary: '#8b5cf6',
  background: '#f3f4f6',
  card: '#ffffff',
  text: '#1f2937'
};

export const Flow: React.FC<FlowProps> = ({ theme = {}, onComplete }) => {
  const [step, setStep] = useState(1);
  const [data, setData] = useState({});
  const appliedTheme = { ...defaultTheme, ...theme };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: appliedTheme.background, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
      <div style={{ backgroundColor: appliedTheme.card, padding: '2.5rem', borderRadius: '1rem', boxShadow: '0 10px 25px rgba(0, 0, 0, 0.1)', maxWidth: '500px', width: '100%' }}>
        <h2 style={{ fontSize: '1.75rem', fontWeight: 700, color: appliedTheme.text, marginBottom: '1.5rem' }}>Flow Step {step}</h2>
        <button onClick={() => step < 3 ? setStep(step + 1) : onComplete?.(data)} style={{ width: '100%', padding: '0.875rem', backgroundColor: appliedTheme.primary, color: '#ffffff', border: 'none', borderRadius: '0.5rem', fontSize: '1rem', fontWeight: 600, cursor: 'pointer' }}>
          {step === 3 ? 'Complete' : 'Next'}
        </button>
      </div>
    </div>
  );
};
