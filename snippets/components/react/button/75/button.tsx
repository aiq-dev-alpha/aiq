import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#8b5cf6';
  
  const handleClick = () => {
  setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
  onInteract?.('click');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  padding: '20px 36px',
  background: state.active ? `linear-gradient(255deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: state.active ? '#ffffff' : primary,
  border: `9px solid ${state.active ? primary : primary + '40'}`,
  borderRadius: '16px',
  fontSize: '22px',
  fontWeight: 1300,
  cursor: 'pointer',
  transition: 'all 330ms cubic-bezier(0.11, 2.6, 0.64, 1)',
  boxShadow: state.active ? `0 24px 44px ${primary}40` : `0 10px 22px rgba(0,0,0,0.16)`,
  transform: state.active ? 'translateY(-12px) scale(1.1)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '16px'
  }}
  >
  <span>Component V18</span>
  {state.count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.55)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {state.count}
  </span>
  )}
  </div>
  );
};