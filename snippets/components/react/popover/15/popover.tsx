import React from 'react';

interface PopoverProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Popover: React.FC<PopoverProps> = ({
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

export default Popover;