import React from 'react';

interface DropdownProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Dropdown: React.FC<DropdownProps> = ({
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

export default Dropdown;