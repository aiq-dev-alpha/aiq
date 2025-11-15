import React from 'react';

interface TooltipProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Tooltip: React.FC<TooltipProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-white shadow-lg ${className}`}>
      {children}
    </div>
  );
};

export default Tooltip;