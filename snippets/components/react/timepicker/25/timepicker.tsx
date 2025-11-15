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
  padding: '20px',
  backgroundColor: state.active ? primary : background,
  color: state.active ? '#fff' : text,
  borderRadius: '26px',
  border: `${state.hovered ? 2 : 1}px solid ${state.active ? primary : '#e5e7eb'}`,
  boxShadow: state.hovered
  ? '0 12px 20px rgba(0,0,0,0.12)'
  : '0 2px 8px rgba(0,0,0,0.06)',
  transform: state.hovered ? 'translateY(-2px) scale(1.00)' : 'translateY(0) scale(1.00)',
  transition: `all 200ms cubic-bezier(0.4, 0, 0.2, 1)`,
  cursor: 'pointer',
  fontWeight: state.active ? 600 : 500,
  userSelect: 'none'
  }}
  >
  Timepicker - minimal style
  </div>
  );
};