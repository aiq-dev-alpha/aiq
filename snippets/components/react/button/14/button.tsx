import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [pulse, setPulse] = useState(false);
  const primary = theme.primary || '#14b8a6';

  return (
  <button
  className={className}
  onClick={() => { setPulse(true); setTimeout(() => setPulse(false), 1000); onInteract?.('pulse'); }}
  style={{
  padding: '16px 36px',
  background: primary,
  color: '#fff',
  border: 'none',
  borderRadius: '12px',
  fontSize: '16px',
  fontWeight: 700,
  cursor: 'pointer',
  position: 'relative',
  boxShadow: pulse ? `0 0 0 0 ${primary}` : `0 0 0 8px ${primary}00`,
  animation: pulse ? 'pulse 1s cubic-bezier(0.4, 0, 0.6, 1)' : 'none',
  outline: 'none'
  }}
  >
  Pulse Button
  <style>{`
  @keyframes pulse {
  0% { box-shadow: 0 0 0 0 ${primary}80; }
  100% { box-shadow: 0 0 0 20px ${primary}00; }
  }
  `}</style>
  </button>
  );
};