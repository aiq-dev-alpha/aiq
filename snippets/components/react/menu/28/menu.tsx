import React from 'react';

interface MenuProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Menu: React.FC<MenuProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-orange-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Menu;