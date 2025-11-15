import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [progress, setProgress] = useState(0);
  const primary = theme.primary || '#f59e0b';
  
  const handleClick = () => {
  setProgress(0);
  const interval = setInterval(() => {
  setProgress(p => {
  if (p >= 100) {
  clearInterval(interval);
  return 100;
  }
  return p + 2;
  });
  }, 20);
  onInteract?.('progress');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  width: '340px',
  padding: '24px',
  background: '#ffffff',
  border: `2px solid ${primary}30`,
  borderRadius: '16px',
  cursor: 'pointer',
  position: 'relative',
  overflow: 'hidden'
  }}
  >
  <div style={{
  position: 'absolute',
  bottom: 0,
  left: 0,
  height: '4px',
  width: `${progress}%`,
  background: primary,
  transition: 'width 50ms linear'
  }} />
  <h3 style={{ margin: '0 0 12px 0', color: primary, fontSize: '20px' }}>
  Progress Card
  </h3>
  <p style={{ margin: 0, color: '#64748b', fontSize: '14px' }}>
  Progress: {progress}% - Click to restart
  </p>
  </div>
  );
};