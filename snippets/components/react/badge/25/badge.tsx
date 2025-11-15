import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
}

export const Component25: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-3 py-2 rounded-md bg-gradient-to-r from-blue-500 to-indigo-600 text-white font-semibold transition-all duration-450';
  
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
