import React from 'react';

interface TextareaProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Textarea: React.FC<TextareaProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-purple-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Textarea;