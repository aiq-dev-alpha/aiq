import React from 'react';

interface ToggleProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Toggle: React.FC<ToggleProps> = ({
  variant = 'default',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-white border border-gray-300 ${className}`}>
      {children}
    </div>
  );
};

export default Toggle;