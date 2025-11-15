import React from 'react';

interface SpinnerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Spinner: React.FC<SpinnerProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-green-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Spinner;