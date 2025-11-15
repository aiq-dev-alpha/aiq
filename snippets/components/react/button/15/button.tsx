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
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
    width: '56px',
    height: '56px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '50%',
    border: 'none',
    cursor: 'pointer',
    fontSize: '24px',
    boxShadow: isHovered
      ? '0 8px 24px rgba(59, 130, 246, 0.5)'
      : '0 4px 12px rgba(0, 0, 0, 0.3)',
    transform: isHovered ? 'scale(1.1) rotate(90deg)' : 'scale(1) rotate(0deg)',
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