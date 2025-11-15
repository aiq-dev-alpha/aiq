import React from 'react';

interface ProgressProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Progress: React.FC<ProgressProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-indigo-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Progress;