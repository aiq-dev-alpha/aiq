import React, { useState, useId } from 'react';

interface FloatingInputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label: string;
  error?: string;
  helperText?: string;
  icon?: React.ReactNode;
}

export const FloatingInput: React.FC<FloatingInputProps> = ({
  label,
  error,
  helperText,
  icon,
  className = '',
  ...props
}) => {
  const [isFocused, setIsFocused] = useState(false);
  const [hasValue, setHasValue] = useState(!!props.value || !!props.defaultValue);
  const id = useId();
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setHasValue(e.target.value.length > 0);
    props.onChange?.(e);
  };
  
  const isFloating = isFocused || hasValue;
  
  return (
    <div className="relative">
      <div className="relative">
        {icon && (
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">
            {icon}
          </div>
        )}
        <input
          id={id}
          onFocus={(e) => {
            setIsFocused(true);
            props.onFocus?.(e);
          }}
          onBlur={(e) => {
            setIsFocused(false);
            props.onBlur?.(e);
          }}
          onChange={handleChange}
          className={`
            w-full px-4 py-3 ${icon ? 'pl-10' : ''}
            border-2 rounded
            transition-all duration-150
            focus:outline-none
            ${error ? 'border-orange-500 focus:border-orange-600' : 'border-gray-300 focus:border-orange-500'}
            ${className}
          `}
          {...props}
        />
        <label
          htmlFor={id}
          className={`
            absolute ${icon ? 'left-10' : 'left-4'} pointer-events-none
            transition-all duration-150 font-medium
            ${isFloating
              ? '-top-2.5 text-xs bg-white px-1 left-3'
              : 'top-1/2 -translate-y-1/2 text-base'
            }
            ${error ? 'text-orange-500' : isFocused ? 'text-orange-500' : 'text-gray-500'}
          `}
        >
          {label}
        </label>
      </div>
      {error && (
        <p className="mt-1 text-sm text-orange-600">{error}</p>
      )}
      {helperText && !error && (
        <p className="mt-1 text-sm text-gray-500">{helperText}</p>
      )}
    </div>
  );
};

export default FloatingInput;