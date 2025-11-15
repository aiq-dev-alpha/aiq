import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [bouncing, setBouncing] = useState(false);
  const primary = theme.primary || '#22c55e';
  return (
  <button className={className} onClick={() => { setBouncing(true); setTimeout(() => setBouncing(false), 600); onInteract?.('bounce'); }}
  style={{ padding: '14px 28px', background: primary, color: '#fff', border: 'none',
  borderRadius: '10px', fontSize: '16px', fontWeight: 700, cursor: 'pointer',
  animation: bouncing ? 'bounce 600ms' : 'none', outline: 'none' }}>
  Bounce
  <style>{\`@keyframes bounce { 0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); } }\`}</style>
  </button>
  );
};