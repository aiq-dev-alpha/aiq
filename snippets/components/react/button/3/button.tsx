import React, { useState, useEffect } from 'react';

export interface ButtonProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Button: React.FC<ButtonProps> = ({
  theme = {},
  className = '',
  onHover
}) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const handleMouseEnter = () => {
    setIsHovered(true);
    onHover?.(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
    onHover?.(false);
  };

  const buttonStyles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 300ms ease',
    padding: '12px 24px',
    backgroundColor: 'transparent',
    color: theme.text || '#111827',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 500,
    position: 'relative',
    overflow: 'hidden',
  };

  const underlineStyles: React.CSSProperties = {
    position: 'absolute',
    bottom: '8px',
    left: '24px',
    right: '24px',
    height: '2px',
    backgroundColor: theme.primary || '#3b82f6',
    transform: isHovered ? 'scaleX(1)' : 'scaleX(0)',
    transformOrigin: 'left',
    transition: 'transform 300ms cubic-bezier(0.4, 0, 0.2, 1)',
  };

  return (
    <div
      className={className}
      style={buttonStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Ghost Button
      <div style={underlineStyles} />
    </div>
  );
};
