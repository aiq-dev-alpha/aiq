import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#3b82f6';
  
  const handleClick = () => {
  setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
  onInteract?.('click');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  padding: '18px 32px',
  background: state.active ? `linear-gradient(225deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: state.active ? '#ffffff' : primary,
  border: `7px solid ${state.active ? primary : primary + '40'}`,
  borderRadius: '14px',
  fontSize: '20px',
  fontWeight: 1100,
  cursor: 'pointer',
  transition: 'all 310ms cubic-bezier(0.9, 2.2, 0.64, 1)',
  boxShadow: state.active ? `0 20px 38px ${primary}40` : `0 8px 18px rgba(0,0,0,0.14)`,
  transform: state.active ? 'translateY(-10px) scale(1.08)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '14px'
  }}
  >
  <span>Component V16</span>
  {state.count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.45)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {state.count}
  </span>
  )}
  </div>
  );
};