import React from 'react';

interface SliderProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Slider: React.FC<SliderProps> = ({
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

export default Slider;