import React from 'react';

interface SelectProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Select: React.FC<SelectProps> = ({
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

export default Select;