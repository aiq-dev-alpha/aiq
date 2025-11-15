import React, { useState } from 'react';

export interface ComponentProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  theme = {},
  className = '',
  onInteract
}) => {
  const [state, setState] = useState({ active: false, hovered: false });

  const primary = theme.primary || '#f97316';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  return (
    <div
      className={className}
      onClick={() => {
        setState(s => ({ ...s, active: !s.active }));
        onInteract?.('interact');
      }}
      onMouseEnter={() => setState(s => ({ ...s, hovered: true }))}
      onMouseLeave={() => setState(s => ({ ...s, hovered: false }))}
      style={{
        padding: '14px 28px',
        backgroundColor: state.active ? primary : background,
        color: state.active ? '#fff' : text,
        borderRadius: '4px',
        border: `${state.hovered ? 2 : 1}px solid ${state.active ? primary : '#e5e7eb'}`,
        boxShadow: state.hovered ? '0 1px 2px rgba(0,0,0,0.05)' : '0 8px 16px rgba(0,0,0,0.15)',
        transform: state.hovered ? 'translateY(-1px) scale(1.01)' : 'translateY(0) scale(1)',
        transition: `all 300ms cubic-bezier(0.4, 0, 0.2, 1)`,
        cursor: 'pointer',
        fontSize: '17px',
        fontWeight: 700,
        userSelect: 'none' as const
      }}
    >
      drawer - variant 18
    </div>
  );
};