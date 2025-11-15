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
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '8px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
  };

  const iconStyles: React.CSSProperties = {
    fontSize: '18px',
    transform: isHovered ? 'translateX(0)' : 'translateX(-10px)',
    opacity: isHovered ? 1 : 0,
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
  };

  return (
    <div
      className={className}
      style={buttonStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <span style={iconStyles}>→</span>
      Icon Slide-In
    </div>
  );
};
