import React from 'react';

interface FilepickerProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Filepicker: React.FC<FilepickerProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow-sm ${className}`}>
      {children}
    </div>
  );
};

export default Filepicker;