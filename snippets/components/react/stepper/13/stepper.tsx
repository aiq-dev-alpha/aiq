import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Component: React.FC<ComponentProps> = ({ 
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
    transform: isVisible 
      ? isHovered 
        ? 'translateY(-5px) scale(1.2)'
        : 'translateY(0) scale(1)'
      : 'translateY(25px) scale(0.95)',
    transition: `all 640ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '31px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '23px',
    border: `${isHovered ? 2 : 1}px solid ${theme.primary ? theme.primary + (isHovered ? 'aa' : '33') : (isHovered ? '#3b82f6aa' : '#e5e7eb')}`,
    boxShadow: isHovered 
      ? '0 11px 21px rgba(0,0,0,0.17)' 
      : '0 6px 17px rgba(0,0,0,0.7)',
    cursor: 'pointer',
  };

  return (
    <div 
      className={className} 
      style={styles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      Component
    </div>
  );
};
