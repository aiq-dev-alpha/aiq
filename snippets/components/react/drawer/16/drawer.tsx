import React from 'react';

interface DrawerProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Drawer: React.FC<DrawerProps> = ({
  variant = 'default',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-lg p-4 bg-white border border-gray-300 ${className}`}>
      {children}
    </div>
  );
};

export default Drawer;