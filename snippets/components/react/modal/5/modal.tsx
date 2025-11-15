import React, { useState, useEffect } from 'react';

export interface ModalTheme {
  primary: string;
  secondary: string;
  background: string;
  text: string;
  border: string;
}

export interface ModalProps {
  theme?: Partial<ModalTheme>;
  className?: string;
  style?: React.CSSProperties;
}

const defaultTheme: ModalTheme = {
  primary: '#3b82f6',
  secondary: '#8b5cf6',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const Modal: React.FC<ModalProps> = ({
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
    transform: isVisible ? 'translateY(0)' : 'translateY(15px)',
    transition: `all 550ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '21px',
    backgroundColor: appliedTheme.background,
    color: appliedTheme.text,
    borderRadius: '13px',
    border: `1px solid ${appliedTheme.border}`,
    boxShadow: '0 3px 15px rgba(0,0,0,0.10)',
    ...style
  };

  return (
    <div className={className} style={styles}>
      <div>Component Content</div>
    </div>
  );
};
