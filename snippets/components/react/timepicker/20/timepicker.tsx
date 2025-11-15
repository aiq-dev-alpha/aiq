import React from 'react';

interface TimepickerProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Timepicker: React.FC<TimepickerProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow-md ${className}`}>
      {children}
    </div>
  );
};

export default Timepicker;