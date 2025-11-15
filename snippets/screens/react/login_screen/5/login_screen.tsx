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
    transform: isVisible ? 'translateY(0)' : 'translateY(15px)',
    transition: `all 550ms ease-out`,
    padding: '21px',
    backgroundColor: theme.background || '#ffffff',
    color: theme.text || '#111827',
    borderRadius: '13px',
    boxShadow: '0 3px 15px rgba(0,0,0,0.1)',
  };

  return <div className={className} style={styles}>Component</div>;
};
