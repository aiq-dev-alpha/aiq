import React, { useState } from 'react';

export interface ComponentProps {
  theme?: {
  primary?: string;
  background?: string;
  text?: string;
  };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  theme = {},
  className = '',
  onInteract
}) => {
  const [loading, setLoading] = useState(false);

  const primary = theme.primary || '#8b5cf6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  const handleClick = () => {
  setLoading(true);
  onInteract?.('loading');
  setTimeout(() => setLoading(false), 2000);
  };

  return (
  <button
  className={className}
  onClick={handleClick}
  disabled={loading}
  style={{
  position: 'relative',
  padding: '14px 32px',
  background: `linear-gradient(135deg, ${primary}, ${primary}dd)`,
  color: '#ffffff',
  border: 'none',
  borderRadius: '12px',
  fontSize: '15px',
  fontWeight: 700,
  cursor: loading ? 'not-allowed' : 'pointer',
  opacity: loading ? 0.7 : 1,
  transition: 'all 300ms ease',
  minWidth: '140px',
  outline: 'none'
  }}
  >
  {loading ? (
  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px' }}>
  <div style={{
  width: '6px',
  height: '6px',
  borderRadius: '50%',
  backgroundColor: '#fff',
  animation: 'bounce 1.4s infinite ease-in-out both',
  animationDelay: '-0.32s'
  }} />
  <div style={{
  width: '6px',
  height: '6px',
  borderRadius: '50%',
  backgroundColor: '#fff',
  animation: 'bounce 1.4s infinite ease-in-out both',
  animationDelay: '-0.16s'
  }} />
  <div style={{
  width: '6px',
  height: '6px',
  borderRadius: '50%',
  backgroundColor: '#fff',
  animation: 'bounce 1.4s infinite ease-in-out both'
  }} />
  <style>{`
  @keyframes bounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
  }
  `}</style>
  </div>
  ) : (
  'Loading Button'
  )}
  </button>
  );
};
