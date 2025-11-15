import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
}

export const Component19: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-7 py-2 rounded-xl bg-gradient-to-r from-pink-500 to-fuchsia-600 text-white font-semibold transition-all duration-390';
  
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
