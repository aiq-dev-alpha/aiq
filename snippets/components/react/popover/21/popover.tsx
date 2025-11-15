import React from 'react';

interface PopoverProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Popover: React.FC<PopoverProps> = ({
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

export default Popover;