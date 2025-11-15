import React from 'react';

interface DatepickerProps {
  variant?: 'text' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Datepicker: React.FC<DatepickerProps> = ({
  variant = 'text',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-full p-4 bg-transparent hover:bg-gray-100 ${className}`}>
      {children}
    </div>
  );
};

export default Datepicker;