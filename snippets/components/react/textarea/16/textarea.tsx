import React from 'react';

interface TextareaProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Textarea: React.FC<TextareaProps> = ({
  variant = 'default',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-lg p-4 bg-white border border-gray-300 ${className}`}>
      {children}
    </div>
  );
};

export default Textarea;