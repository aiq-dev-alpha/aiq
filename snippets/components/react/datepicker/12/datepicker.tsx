import React from 'react';

interface DatepickerProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Datepicker: React.FC<DatepickerProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-orange-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Datepicker;