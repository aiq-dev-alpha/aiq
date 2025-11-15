import React, { useState, useEffect } from 'react';

export interface FlowProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
}

export const Flow: React.FC<FlowProps> = ({ theme = {}, className = '' }) => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'translateY(0)' : 'translateY(21px)',
    transition: `all 850ms ease-out`,
    padding: '27px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '19px',
    boxShadow: '0 5px 11px rgba(0,0,0,0.1)',
  };

  return <div className={className} style={styles}>Component</div>;
};
