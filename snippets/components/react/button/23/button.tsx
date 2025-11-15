import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  gradient?: boolean;
  theme?: { primary?: string; secondary?: string; text?: string };
  className?: string;
  onClick?: () => void;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Button',
  gradient = true,
  theme = {},
  className = '',
  onClick
}) => {
  const [isActive, setIsActive] = useState(false);

  const primary = theme.primary || '#8b5cf6';
  const secondary = theme.secondary || '#ec4899';
  const text = theme.text || '#ffffff';

  return (
  <button
  className={className}
  onClick={() => {
  setIsActive(!isActive);
  onClick?.();
  }}
  style={{
  padding: '14px 36px',
  background: gradient 
  ? `linear-gradient(135deg, ${primary}, ${secondary})`
  : primary,
  color: text,
  border: 'none',
  borderRadius: '50px',
  fontSize: '16px',
  fontWeight: 700,
  cursor: 'pointer',
  boxShadow: isActive 
  ? `0 0 0 4px ${primary}40, 0 8px 16px rgba(0,0,0,0.2)`
  : '0 4px 12px rgba(0,0,0,0.15)',
  transform: isActive ? 'translateY(0)' : 'translateY(-1px)',
  transition: 'all 200ms cubic-bezier(0.4, 0, 0.2, 1)',
  outline: 'none',
  letterSpacing: '0.5px',
  textTransform: 'uppercase' as const
  }}
  >
  {label}
  </button>
  );
};