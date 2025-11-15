import React from 'react';

interface StepperProps {
  variant?: 'elevated' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Stepper: React.FC<StepperProps> = ({
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

export default Stepper;