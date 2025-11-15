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
        padding: '19px 34px',
        background: state.active ? `linear-gradient(240deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: state.active ? '#ffffff' : primary,
        border: `8px solid ${state.active ? primary : primary + '40'}`,
        borderRadius: '15px',
        fontSize: '21px',
        fontWeight: 1200,
        cursor: 'pointer',
        transition: 'all 320ms cubic-bezier(0.10, 2.4000000000000004, 0.64, 1)',
        boxShadow: state.active ? `0 22px 41px ${primary}40` : `0 9px 20px rgba(0,0,0,0.15)`,
        transform: state.active ? 'translateY(-11px) scale(1.09)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '15px'
      }}
    >
      <span>Component V17</span>
      {state.count > 0 && (
        <span style={{ 
          fontSize: '12px', 
          background: 'rgba(255,255,255,0.50)', 
          padding: '2px 8px', 
          borderRadius: '12px' 
        }}>
          {state.count}
        </span>
      )}
    </div>
  );
};