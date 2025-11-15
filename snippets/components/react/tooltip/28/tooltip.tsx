import React from 'react';

interface TooltipProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Tooltip: React.FC<TooltipProps> = ({
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

export default Tooltip;