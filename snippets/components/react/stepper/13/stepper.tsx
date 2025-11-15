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

  const primary = theme.primary || '#ef4444';
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
        padding: '18px 36px',
        backgroundColor: state.active ? primary : background,
        color: state.active ? '#fff' : text,
        borderRadius: '12px',
        border: `${state.hovered ? 2 : 1}px solid ${state.active ? primary : '#e5e7eb'}`,
        boxShadow: state.hovered ? '0 4px 8px rgba(0,0,0,0.10)' : '0 12px 24px rgba(0,0,0,0.20)',
        transform: state.hovered ? 'translateY(-2px) scale(1.02)' : 'translateY(0) scale(1)',
        transition: `all 400ms cubic-bezier(0.4, 0, 0.2, 1)`,
        cursor: 'pointer',
        fontSize: '19px',
        fontWeight: 700,
        userSelect: 'none' as const
      }}
    >
      stepper - variant 13
    </div>
  );
};