import React from 'react';

interface RangepickerProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Rangepicker: React.FC<RangepickerProps> = ({
  variant = 'elevated',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded p-4 bg-white shadow ${className}`}>
      {children}
    </div>
  );
};

export default Rangepicker;