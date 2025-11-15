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
        padding: '21px 38px',
        background: state.active ? `linear-gradient(270deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: state.active ? '#ffffff' : primary,
        border: `10px solid ${state.active ? primary : primary + '40'}`,
        borderRadius: '17px',
        fontSize: '23px',
        fontWeight: 1400,
        cursor: 'pointer',
        transition: 'all 340ms cubic-bezier(0.12, 2.8, 0.64, 1)',
        boxShadow: state.active ? `0 26px 47px ${primary}40` : `0 11px 24px rgba(0,0,0,0.17)`,
        transform: state.active ? 'translateY(-13px) scale(1.11)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '17px'
      }}
    >
      <span>Component V19</span>
      {state.count > 0 && (
        <span style={{ 
          fontSize: '12px', 
          background: 'rgba(255,255,255,0.60)', 
          padding: '2px 8px', 
          borderRadius: '12px' 
        }}>
          {state.count}
        </span>
      )}
    </div>
  );
};