import React from 'react';

interface DialogProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Dialog: React.FC<DialogProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-red-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Dialog;