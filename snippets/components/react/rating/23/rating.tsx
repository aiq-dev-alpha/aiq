import React from 'react';

interface RatingProps {
  variant?: 'outlined' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Rating: React.FC<RatingProps> = ({
  variant = 'outlined',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-2xl p-4 border-2 border-indigo-500 bg-transparent ${className}`}>
      {children}
    </div>
  );
};

export default Rating;