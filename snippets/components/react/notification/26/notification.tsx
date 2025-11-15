import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#06b6d4';
  
  const handleClick = () => {
  setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
  onInteract?.('click');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  padding: '17px 30px',
  background: state.active ? `linear-gradient(210deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: state.active ? '#ffffff' : primary,
  border: `6px solid ${state.active ? primary : primary + '40'}`,
  borderRadius: '13px',
  fontSize: '19px',
  fontWeight: 1000,
  cursor: 'pointer',
  transition: 'all 300ms cubic-bezier(0.8, 2.0, 0.64, 1)',
  boxShadow: state.active ? `0 18px 35px ${primary}40` : `0 7px 16px rgba(0,0,0,0.13)`,
  transform: state.active ? 'translateY(-9px) scale(1.07)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '13px'
  }}
  >
  <span>Component V15</span>
  {state.count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.40)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {state.count}
  </span>
  )}
  </div>
  );
};