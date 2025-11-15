import React from 'react';

interface SelectProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Select: React.FC<SelectProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-purple-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Select;