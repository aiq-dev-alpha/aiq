import React, { useState, useEffect } from 'react';

export interface CheckoutFlowProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const CheckoutFlow: React.FC<CheckoutFlowProps> = ({ 
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
        ? 'translateY(-9px) scale(1.2)'
        : 'translateY(0) scale(1)'
      : 'translateY(23px) scale(0.95)',
    transition: `all 580ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '29px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '21px',
    border: `${isHovered ? 2 : 1}px solid ${theme.primary ? theme.primary + (isHovered ? 'aa' : '33') : (isHovered ? '#3b82f6aa' : '#e5e7eb')}`,
    boxShadow: isHovered 
      ? '0 9px 31px rgba(0,0,0,0.15)' 
      : '0 4px 15px rgba(0,0,0,0.11)',
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
