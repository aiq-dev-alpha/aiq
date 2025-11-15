import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#10b981';
  
  const handleClick = () => {
  setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
  onInteract?.('click');
  };
  
  return (
  <div
  className={className}
  onClick={handleClick}
  style={{
  padding: '13px 22px',
  background: state.active ? `linear-gradient(150deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: state.active ? '#ffffff' : primary,
  border: `2px solid ${state.active ? primary : primary + '40'}`,
  borderRadius: '9px',
  fontSize: '15px',
  fontWeight: 600,
  cursor: 'pointer',
  transition: 'all 260ms cubic-bezier(0.4, 1.2, 0.64, 1)',
  boxShadow: state.active ? `0 10px 23px ${primary}40` : `0 3px 8px rgba(0,0,0,0.9)`,
  transform: state.active ? 'translateY(-5px) scale(1.03)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '9px'
  }}
  >
  <span>Component V11</span>
  {state.count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.20)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {state.count}
  </span>
  )}
  </div>
  );
};