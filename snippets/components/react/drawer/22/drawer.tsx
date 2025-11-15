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
    <div className={`rounded-xl p-4 bg-pink-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Drawer;