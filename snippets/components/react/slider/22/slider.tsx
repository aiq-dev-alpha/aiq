import React, { useState, useEffect } from 'react';

export interface ComponentTheme {
  primary: string;
  secondary: string;
  background: string;
  text: string;
  border: string;
}

export interface ComponentProps {
  theme?: Partial<ComponentTheme>;
  className?: string;
  style?: React.CSSProperties;
}

const defaultTheme: ComponentTheme = {
  primary: '#3b82f6',
  secondary: '#8b5cf6',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const Component: React.FC<ComponentProps> = ({
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
    transform: isVisible ? 'translateY(0)' : 'translateY(12px)',
    transition: `all 700ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '26px',
    backgroundColor: appliedTheme.background,
    color: appliedTheme.text,
    borderRadius: '18px',
    border: `1px solid ${appliedTheme.border}`,
    boxShadow: '0 4px 12px rgba(0,0,0,0.7)',
    ...style
  };

  return (
    <div className={className} style={styles}>
      <div>Component Content</div>
    </div>
  );
};
