import React from 'react';

interface AutocompleteProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Autocomplete: React.FC<AutocompleteProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-red-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Autocomplete;