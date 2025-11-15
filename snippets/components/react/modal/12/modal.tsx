import React, { useState, useEffect } from 'react';

export interface ModalProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
}

export const Modal: React.FC<ModalProps> = ({ theme = {}, className = '' }) => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'translateY(0)' : 'translateY(22px)',
    transition: `all 900ms ease-out`,
    padding: '16px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '8px',
    boxShadow: '0 2px 12px rgba(0,0,0,0.1)',
  };

  return <div className={className} style={styles}>Component</div>;
};
