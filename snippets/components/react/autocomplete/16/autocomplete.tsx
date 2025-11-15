import React from 'react';

interface AutocompleteProps {
  variant?: 'default' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Autocomplete: React.FC<AutocompleteProps> = ({
  variant = 'default',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-lg p-4 bg-white border border-gray-300 ${className}`}>
      {children}
    </div>
  );
};

export default Autocomplete;