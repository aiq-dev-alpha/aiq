import React from 'react';

interface TabsProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Tabs: React.FC<TabsProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-indigo-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Tabs;