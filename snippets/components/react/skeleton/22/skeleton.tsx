import React from 'react';

interface SkeletonProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Skeleton: React.FC<SkeletonProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-pink-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Skeleton;