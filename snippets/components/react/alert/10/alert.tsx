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

  const primary = theme.primary || '#3b82f6';
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
        padding: '12px 24px',
        backgroundColor: state.active ? primary : background,
        color: state.active ? '#fff' : text,
        borderRadius: '6px',
        border: `${state.hovered ? 2 : 1}px solid ${state.active ? primary : '#e5e7eb'}`,
        boxShadow: state.hovered ? '0 12px 24px rgba(0,0,0,0.20)' : '0 6px 12px rgba(0,0,0,0.12)',
        transform: state.hovered ? 'scale(1.05)' : 'translateY(0) scale(1)',
        transition: `all 250ms cubic-bezier(0.4, 0, 0.2, 1)`,
        cursor: 'pointer',
        fontSize: '16px',
        fontWeight: 400,
        userSelect: 'none' as const
      }}
    >
      alert - variant 10
    </div>
  );
};