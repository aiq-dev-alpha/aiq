import React from 'react';

interface FilepickerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Filepicker: React.FC<FilepickerProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-green-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Filepicker;