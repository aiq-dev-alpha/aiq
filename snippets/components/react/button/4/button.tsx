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
  const [isHovered, setIsHovered] = useState(false);

  const primary = theme.primary || '#f59e0b';
  const background = theme.background || '#fffbeb';
  const text = theme.text || '#92400e';

  return (
    <button
      className={className}
      onClick={() => onInteract?.('click')}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      style={{
        position: 'relative',
        padding: '16px 36px',
        background: 'transparent',
        color: primary,
        border: `3px solid ${primary}`,
        borderRadius: '50px',
        fontSize: '16px',
        fontWeight: 800,
        cursor: 'pointer',
        overflow: 'hidden',
        transition: 'color 400ms ease',
        textTransform: 'uppercase',
        letterSpacing: '1.5px',
        outline: 'none'
      }}
    >
      <span style={{
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        backgroundColor: primary,
        transform: isHovered ? 'translateY(0)' : 'translateY(100%)',
        transition: 'transform 400ms cubic-bezier(0.175, 0.885, 0.32, 1.275)',
        zIndex: -1
      }} />
      <span style={{
        position: 'relative',
        zIndex: 1,
        color: isHovered ? '#ffffff' : primary,
        transition: 'color 400ms ease'
      }}>
        Slide Fill
      </span>
    </button>
  );
};
