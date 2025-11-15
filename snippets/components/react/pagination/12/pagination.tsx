import React from 'react';

interface PaginationProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Pagination: React.FC<PaginationProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-orange-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Pagination;