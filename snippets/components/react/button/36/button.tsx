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
    padding: '12px 24px',
    backgroundColor: isHovered ? '#10b981dd' : (theme.primary || '#10b981'),
    color: '#ffffff',
    borderRadius: '12px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    transform: isHovered ? 'scale(1.05)' : 'scale(1)',
    boxShadow: isHovered ? '0 6px 20px rgba(0, 0, 0, 0.2)' : '0 2px 8px rgba(0, 0, 0, 0.1)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Badge Button
    </div>
  );
};