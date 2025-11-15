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
    transition: 'all 150ms ease',
    padding: '14px 28px',
    backgroundColor: theme.background || '#e0e5ec',
    color: theme.text || '#6b7280',
    borderRadius: '12px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    boxShadow: isPressed
      ? 'inset 4px 4px 8px rgba(163, 177, 198, 0.6), inset -4px -4px 8px rgba(255, 255, 255, 0.5)'
      : '6px 6px 12px rgba(163, 177, 198, 0.6), -6px -6px 12px rgba(255, 255, 255, 0.5)',
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
      Neumorphism
    </div>
  );
};
