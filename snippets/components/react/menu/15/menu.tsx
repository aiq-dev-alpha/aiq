import React from 'react';

interface MenuProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Menu: React.FC<MenuProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow-lg ${className}`}>
      {children}
    </div>
  );
};

export default Menu;