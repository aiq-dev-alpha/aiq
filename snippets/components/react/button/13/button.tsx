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
    width: '100%',
    padding: '16px',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '8px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    fontSize: '16px',
    textAlign: 'center',
    transform: isHovered ? 'translateY(-2px)' : 'translateY(0)',
    boxShadow: isHovered ? '0 8px 16px rgba(59, 130, 246, 0.3)' : '0 2px 8px rgba(0, 0, 0, 0.1)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Full Width Block
    </div>
  );
};