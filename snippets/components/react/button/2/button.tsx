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
    transform: isVisible ? 'translateY(0)' : 'translateY(10px)',
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
    padding: '12px 24px',
    backgroundColor: 'transparent',
    color: theme.primary || '#3b82f6',
    borderRadius: '8px',
    border: '2px solid transparent',
    backgroundImage: isHovered
      ? `linear-gradient(${theme.background || '#ffffff'}, ${theme.background || '#ffffff'}), linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
      : `linear-gradient(${theme.background || '#ffffff'}, ${theme.background || '#ffffff'}), linear-gradient(135deg, ${theme.primary || '#3b82f6'} 0%, #8b5cf6 100%)`,
    backgroundOrigin: 'border-box',
    backgroundClip: 'padding-box, border-box',
    cursor: 'pointer',
    fontWeight: 600,
    position: 'relative',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Outlined Gradient
    </div>
  );
};
