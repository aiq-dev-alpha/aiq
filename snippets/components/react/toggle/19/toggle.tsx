import React from 'react';

interface ToggleProps {
  variant?: 'text' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Toggle: React.FC<ToggleProps> = ({
  variant = 'text',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-transparent hover:bg-gray-100 ${className}`}>
      {children}
    </div>
  );
};

export default Toggle;