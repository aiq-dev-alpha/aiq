import React from 'react';

interface TreeProps {
  variant?: 'text' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Tree: React.FC<TreeProps> = ({
  variant = 'text',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-transparent hover:bg-gray-100 ${className}`}>
      {children}
    </div>
  );
};

export default Tree;