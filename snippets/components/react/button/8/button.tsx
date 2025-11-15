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
    padding: '14px 28px',
    background: 'rgba(255, 255, 255, 0.2)',
    backdropFilter: 'blur(10px)',
    WebkitBackdropFilter: 'blur(10px)',
    color: theme.text || '#111827',
    borderRadius: '12px',
    border: '1px solid rgba(255, 255, 255, 0.3)',
    cursor: 'pointer',
    fontWeight: 600,
    boxShadow: isHovered
      ? '0 8px 32px rgba(0, 0, 0, 0.2)'
      : '0 4px 16px rgba(0, 0, 0, 0.1)',
    transform: isHovered ? 'translateY(-2px)' : 'translateY(0)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Glassmorphism
    </div>
  );
};
