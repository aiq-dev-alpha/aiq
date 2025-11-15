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
        padding: '14px 24px',
        background: state.active ? `linear-gradient(165deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: state.active ? '#ffffff' : primary,
        border: `3px solid ${state.active ? primary : primary + '40'}`,
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        transition: 'all 270ms cubic-bezier(0.5, 1.4, 0.64, 1)',
        boxShadow: state.active ? `0 12px 26px ${primary}40` : `0 4px 10px rgba(0,0,0,0.10)`,
        transform: state.active ? 'translateY(-6px) scale(1.04)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '10px'
      }}
    >
      <span>Component V12</span>
      {state.count > 0 && (
        <span style={{ 
          fontSize: '12px', 
          background: 'rgba(255,255,255,0.25)', 
          padding: '2px 8px', 
          borderRadius: '12px' 
        }}>
          {state.count}
        </span>
      )}
    </div>
  );
};