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
    background: isHovered
      ? 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)'
      : 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    backgroundSize: isHovered ? '200% 100%' : '100% 100%',
    color: '#ffffff',
    borderRadius: '10px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    boxShadow: '0 4px 15px rgba(102, 126, 234, 0.4)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Gradient Animate
    </div>
  );
};
