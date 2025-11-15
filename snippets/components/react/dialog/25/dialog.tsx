import React from 'react';

interface DialogProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Dialog: React.FC<DialogProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow ${className}`}>
      {children}
    </div>
  );
};

export default Dialog;