import React from 'react';

interface RatingProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Rating: React.FC<RatingProps> = ({
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

export default Rating;