import React from 'react';

interface ColorpickerProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Colorpicker: React.FC<ColorpickerProps> = ({
  variant = 'default',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-white border border-gray-300 ${className}`}>
      {children}
    </div>
  );
};

export default Colorpicker;