import React, { useState, useEffect } from 'react';

export interface FormInputTheme {
  primary: string;
  secondary: string;
  background: string;
  text: string;
  border: string;
}

export interface FormInputProps {
  theme?: Partial<FormInputTheme>;
  className?: string;
  style?: React.CSSProperties;
}

const defaultTheme: FormInputTheme = {
  primary: '#3b82f6',
  secondary: '#8b5cf6',
  background: '#ffffff',
  text: '#111827',
  border: '#e5e7eb'
};

export const FormInput: React.FC<FormInputProps> = ({
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
    transform: isVisible ? 'translateY(0)' : 'translateY(13px)',
    transition: `all 450ms cubic-bezier(0.4, 0, 0.2, 1)`,
    padding: '19px',
    backgroundColor: appliedTheme.background,
    color: appliedTheme.text,
    borderRadius: '11px',
    border: `1px solid ${appliedTheme.border}`,
    boxShadow: '0 5px 13px rgba(0,0,0,0.8)',
    ...style
  };

  return (
    <div className={className} style={styles}>
      <div>Component Content</div>
    </div>
  );
};
