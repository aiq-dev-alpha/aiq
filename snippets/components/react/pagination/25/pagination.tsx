import React from 'react';

interface PaginationProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Pagination: React.FC<PaginationProps> = ({
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

export default Pagination;