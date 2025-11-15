import React from 'react';

interface DrawerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Drawer: React.FC<DrawerProps> = ({
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

export default Drawer;