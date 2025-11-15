import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
}

export const Component29: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-7 py-3 rounded-md bg-gradient-to-r from-pink-600 to-fuchsia-700 text-white font-bold transition-all duration-490';
  
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
