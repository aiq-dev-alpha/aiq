import React from 'react';

interface ColorpickerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Colorpicker: React.FC<ColorpickerProps> = ({
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

export default Colorpicker;