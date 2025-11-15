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
    <div className={`rounded-xl p-4 bg-red-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Chip;