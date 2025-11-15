import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [state, setState] = useState({{ active: false, count: 0 }});
  const primary = theme.primary || '#ef4444';
  
  const handleClick = () => {
    setState(prev => ({ active: !prev.active, count: prev.count + 1 }));
    onInteract?.('click');
  };
  
  return (
    <div
      className={className}
      onClick={handleClick}
      style={{
        padding: '16px 28px',
        background: state.active ? `linear-gradient(195deg, ${primary}, ${primary}dd)` : '#ffffff',
        color: state.active ? '#ffffff' : primary,
        border: `5px solid ${state.active ? primary : primary + '40'}`,
        borderRadius: '12px',
        fontSize: '18px',
        fontWeight: 900,
        cursor: 'pointer',
        transition: 'all 290ms cubic-bezier(0.7, 1.8, 0.64, 1)',
        boxShadow: state.active ? `0 16px 32px ${primary}40` : `0 6px 14px rgba(0,0,0,0.12)`,
        transform: state.active ? 'translateY(-8px) scale(1.06)' : 'translateY(0) scale(1)',
        display: 'inline-flex',
        alignItems: 'center',
        gap: '12px'
      }}
    >
      <span>Component V14</span>
      {state.count > 0 && (
        <span style={{ 
          fontSize: '12px', 
          background: 'rgba(255,255,255,0.35)', 
          padding: '2px 8px', 
          borderRadius: '12px' 
        }}>
          {state.count}
        </span>
      )}
    </div>
  );
};