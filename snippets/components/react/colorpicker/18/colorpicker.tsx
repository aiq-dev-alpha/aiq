import React from 'react';

interface ColorpickerProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Colorpicker: React.FC<ColorpickerProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-purple-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Colorpicker;