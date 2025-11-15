import React from 'react';
interface Props {
  children?: React.ReactNode;
  className?: string;
}
export const Component21: React.FC<Props> = ({ children, className = '' }) => {
  const baseStyles = 'inline-flex items-center justify-center px-4 py-1 rounded-md bg-gradient-to-r from-purple-400 to-violet-500 text-white font-medium transition-all duration-410';
  return (
    <div className={`${baseStyles} ${className}`}>
      {children}
    </div>
  );
};

export default Component21;