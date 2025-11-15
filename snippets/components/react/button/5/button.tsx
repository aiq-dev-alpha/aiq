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
    padding: '12px 32px',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '50px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
    animation: isHovered ? 'pulse 1.5s infinite' : 'none',
    boxShadow: isHovered ? '0 0 0 8px rgba(59, 130, 246, 0.2)' : 'none',
  };

  return (
    <>
      <style>
        {`
          @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
          }
        `}
      </style>
      <div
        className={className}
        style={styles}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
      >
        Pill Pulse
      </div>
    </>
  );
};
