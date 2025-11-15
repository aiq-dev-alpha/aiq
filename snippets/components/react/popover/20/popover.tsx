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
    <div className={`rounded p-4 bg-white shadow-md ${className}`}>
      {children}
    </div>
  );
};

export default Popover;