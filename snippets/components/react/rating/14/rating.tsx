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

  const primary = theme.primary || '#f59e0b';
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
        padding: '6px 12px',
        backgroundColor: state.active ? primary : background,
        color: state.active ? '#fff' : text,
        borderRadius: '16px',
        border: `${state.hovered ? 2 : 1}px solid ${state.active ? primary : '#e5e7eb'}`,
        boxShadow: state.hovered ? '0 6px 12px rgba(0,0,0,0.12)' : '0 1px 2px rgba(0,0,0,0.05)',
        transform: state.hovered ? 'translateY(-3px) scale(1.03)' : 'translateY(0) scale(1)',
        transition: `all 100ms cubic-bezier(0.4, 0, 0.2, 1)`,
        cursor: 'pointer',
        fontSize: '13px',
        fontWeight: 800,
        userSelect: 'none' as const
      }}
    >
      rating - variant 14
    </div>
  );
};