import React from 'react';

interface TextareaProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Textarea: React.FC<TextareaProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow-md ${className}`}>
      {children}
    </div>
  );
};

export default Textarea;