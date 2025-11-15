import React from 'react';

interface SpinnerProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Spinner: React.FC<SpinnerProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-indigo-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Spinner;