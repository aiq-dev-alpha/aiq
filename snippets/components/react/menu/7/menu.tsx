import React from 'react';

interface MenuProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Menu: React.FC<MenuProps> = ({
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

export default Menu;