import React from 'react';

interface ChipProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Chip: React.FC<ChipProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-blue-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Chip;