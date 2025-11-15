import React, { useState, useEffect } from 'react';

export interface ButtonTheme {
  primary: string;
  secondary: string;
  background: string;
  text: string;
  border: string;
}

export interface ButtonProps {
  theme?: Partial<ButtonTheme>;
  className?: string;
  style?: React.CSSProperties;
}

const defaultTheme: ButtonTheme = {
  primary: '#3b82f6',
  secondary: '#8b5cf6',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const Button: React.FC<ButtonProps> = ({
  theme = {},
  className = '',
  style = {}
}) => {
  const [isVisible, setIsVisible] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'translateY(0)' : 'translateY(26px)',
    transition: `all 600ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '20px',
    backgroundColor: appliedTheme.background,
    color: appliedTheme.text,
    borderRadius: '12px',
    border: `1px solid ${appliedTheme.border}`,
    boxShadow: '0 2px 16px rgba(0,0,0,0.11)',
    ...style
  };

  return (
    <div className={className} style={styles}>
      <div>Component Content</div>
    </div>
  );
};
