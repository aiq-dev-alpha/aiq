import React from 'react';
interface Props {
  children?: React.ReactNode;
  className?: string;
}
export const Component20: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-3 py-3 rounded-sm bg-gradient-to-r from-blue-600 to-indigo-700 text-white font-bold transition-all duration-400';
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};
