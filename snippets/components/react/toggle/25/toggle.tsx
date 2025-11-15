import React from 'react';

interface ToggleProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Toggle: React.FC<ToggleProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-white shadow-lg ${className}`}>
      {children}
    </div>
  );
};

export default Toggle;