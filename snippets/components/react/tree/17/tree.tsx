import React from 'react';

interface TreeProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Tree: React.FC<TreeProps> = ({
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

export default Tree;