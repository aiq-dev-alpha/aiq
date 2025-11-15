import React from 'react';

interface AlertProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Alert: React.FC<AlertProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-red-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Alert;