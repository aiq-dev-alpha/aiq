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

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 300ms ease',
    width: '48px',
    height: '48px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '50%',
    border: 'none',
    cursor: 'pointer',
    fontSize: '20px',
    transform: isHovered ? 'scale(1.1)' : 'scale(1)',
    boxShadow: isHovered ? '0 6px 20px rgba(59, 130, 246, 0.4)' : '0 2px 8px rgba(0, 0, 0, 0.1)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      +
    </div>
  );
};