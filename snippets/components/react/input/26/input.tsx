import React, { useState, useEffect } from 'react';

export interface InputProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Input: React.FC<InputProps> = ({ 
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
        ? 'translateY(-6px) scale(1.1)'
        : 'translateY(0) scale(1)'
      : 'translateY(20px) scale(0.95)',
    transition: `all 430ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '30px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '22px',
    border: `${isHovered ? 2 : 1}px solid ${theme.primary ? theme.primary + (isHovered ? 'aa' : '33') : (isHovered ? '#3b82f6aa' : '#e5e7eb')}`,
    boxShadow: isHovered 
      ? '0 8px 22px rgba(0,0,0,0.14)' 
      : '0 4px 14px rgba(0,0,0,0.8)',
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
