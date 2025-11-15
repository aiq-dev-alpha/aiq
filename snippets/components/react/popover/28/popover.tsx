import React from 'react';

interface PopoverProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Popover: React.FC<PopoverProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-orange-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Popover;