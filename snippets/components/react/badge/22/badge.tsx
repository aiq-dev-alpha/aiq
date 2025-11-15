import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
}

export const Component22: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-5 py-2 rounded-lg bg-gradient-to-r from-green-500 to-emerald-600 text-white font-semibold transition-all duration-420';
  
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
