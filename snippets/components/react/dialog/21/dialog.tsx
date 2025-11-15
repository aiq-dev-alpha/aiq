import React from 'react';

interface DialogProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Dialog: React.FC<DialogProps> = ({
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

export default Dialog;