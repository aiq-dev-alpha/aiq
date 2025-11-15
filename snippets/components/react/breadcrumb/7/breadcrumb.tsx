import React from 'react';

interface BreadcrumbProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Breadcrumb: React.FC<BreadcrumbProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-indigo-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Breadcrumb;