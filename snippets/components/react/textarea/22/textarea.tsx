import React from 'react';

interface TextareaProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Textarea: React.FC<TextareaProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-blue-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Textarea;