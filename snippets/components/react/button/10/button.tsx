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
  const [isPressed, setIsPressed] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const handleMouseEnter = () => {
    onHover?.(true);
  };

  const handleMouseLeave = () => {
    onHover?.(false);
    setIsPressed(false);
  };

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 100ms ease',
    padding: '14px 28px',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '8px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    boxShadow: isPressed
      ? '0 2px 4px rgba(0, 0, 0, 0.2)'
      : '0 6px 0 #1d4ed8, 0 8px 12px rgba(0, 0, 0, 0.3)',
    transform: isPressed ? 'translateY(4px)' : 'translateY(0)',
  };

  return (
    <div
      className={className}
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
    >
      3D Elevated
    </div>
  );
};
