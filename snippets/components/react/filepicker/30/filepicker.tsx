import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '' }) => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
    transition: `all 400ms ease-out`,
    padding: '22px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '14px',
    boxShadow: '0 4px 10px rgba(0,0,0,0.1)',
  };

  return <div className={className} style={styles}>Component</div>;
};
