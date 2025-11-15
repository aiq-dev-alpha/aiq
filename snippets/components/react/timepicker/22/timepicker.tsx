import React from 'react';

interface TimepickerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Timepicker: React.FC<TimepickerProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-pink-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Timepicker;