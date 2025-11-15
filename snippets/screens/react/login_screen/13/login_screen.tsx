import React, { useState, useEffect } from 'react';

export interface LoginScreenProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
}

export const LoginScreen: React.FC<LoginScreenProps> = ({ theme = {}, className = '' }) => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'translateY(0)' : 'translateY(23px)',
    transition: `all 950ms ease-out`,
    padding: '17px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '9px',
    boxShadow: '0 3px 13px rgba(0,0,0,0.1)',
  };

  return <div className={className} style={styles}>Component</div>;
};
