import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#f59e0b';
  
  const handleClick = () => {
  setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
  onInteract?.('click');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  padding: '15px 26px',
  background: state.active ? `linear-gradient(180deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: state.active ? '#ffffff' : primary,
  border: `4px solid ${state.active ? primary : primary + '40'}`,
  borderRadius: '11px',
  fontSize: '17px',
  fontWeight: 800,
  cursor: 'pointer',
  transition: 'all 280ms cubic-bezier(0.6, 1.6, 0.64, 1)',
  boxShadow: state.active ? `0 14px 29px ${primary}40` : `0 5px 12px rgba(0,0,0,0.11)`,
  transform: state.active ? 'translateY(-7px) scale(1.05)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '11px'
  }}
  >
  <span>Component V13</span>
  {state.count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.30)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {state.count}
  </span>
  )}
  </div>
  );
};