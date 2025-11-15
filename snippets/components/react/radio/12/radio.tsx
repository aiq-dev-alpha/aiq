import React from 'react';

interface RadioProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Radio: React.FC<RadioProps> = ({
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

export default Radio;