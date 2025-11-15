import React from 'react';

interface DatepickerProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Datepicker: React.FC<DatepickerProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-md p-4 bg-white shadow-lg ${className}`}>
      {children}
    </div>
  );
};

export default Datepicker;