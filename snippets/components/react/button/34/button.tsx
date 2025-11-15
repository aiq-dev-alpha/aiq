import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [isHovered, setIsHovered] = useState(false);
  const primary = theme.primary || '#ef4444';

  return (
  <button
  className={className}
  onMouseEnter={() => setIsHovered(true)}
  onMouseLeave={() => setIsHovered(false)}
  onClick={() => onInteract?.('click')}
  style={{
  padding: '10px 24px',
  backgroundColor: isHovered ? `${primary}10` : 'transparent',
  color: primary,
  border: 'none',
  borderRadius: '24px',
  fontSize: '14px',
  fontWeight: 500,
  cursor: 'pointer',
  transition: 'background-color 200ms ease'
  }}
  >
  Ghost Button
  </button>
  );
};
