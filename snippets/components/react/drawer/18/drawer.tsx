import React from 'react';

interface DrawerProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Drawer: React.FC<DrawerProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 border-2 border-blue-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Drawer;