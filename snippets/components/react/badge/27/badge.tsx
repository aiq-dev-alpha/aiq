import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
}

export const Component27: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-5 py-1 rounded-xl bg-gradient-to-r from-green-400 to-emerald-500 text-white font-medium transition-all duration-470';
  
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
