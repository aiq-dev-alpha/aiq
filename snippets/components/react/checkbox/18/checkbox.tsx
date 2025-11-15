import React from 'react';

interface CheckboxProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Checkbox: React.FC<CheckboxProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 border-2 border-blue-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Checkbox;