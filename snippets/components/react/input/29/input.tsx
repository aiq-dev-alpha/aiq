import React, { useState, useId } from 'react';

interface CountingInputProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'maxLength'> {
  label?: string;
  maxLength: number;
  showCount?: boolean;
  variant?: 'outlined' | 'filled';
}

export const CountingInput: React.FC<CountingInputProps> = ({
  label,
  maxLength,
  showCount = true,
  variant = 'outlined',
  className = '',
  ...props
}) => {
  const [value, setValue] = useState(String(props.value || props.defaultValue || ''));
  const id = useId();
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (newValue.length <= maxLength) {
      setValue(newValue);
      props.onChange?.(e);
    }
  };
  
  const percentage = (value.length / maxLength) * 100;
  const isNearLimit = percentage >= 90;
  
  const variants = {
    outlined: 'border-2 border-gray-300 bg-white focus:border-teal-500',
    filled: 'border-0 bg-gray-100 focus:bg-gray-200'
  };
  
  return (
    <div>
      {label && (
        <label htmlFor={id} className="block text-sm font-medium text-gray-700 mb-1">
          {label}
        </label>
      )}
      <div className="relative">
        <input
          id={id}
          value={value}
          onChange={handleChange}
          className={`
            w-full px-4 py-2.5 rounded-full
            transition-all duration-200
            focus:outline-none focus:ring-2 focus:ring-teal-500
            ${variants[variant]}
            ${className}
          `}
          {...props}
        />
        {showCount && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2">
            <span className={`text-xs font-medium ${
              isNearLimit ? 'text-teal-600' : 'text-gray-500'
            }`}>
              {value.length}/{maxLength}
            </span>
          </div>
        )}
      </div>
      {showCount && (
        <div className="mt-1 h-1 bg-gray-200 rounded-full overflow-hidden">
          <div
            className={`h-full transition-all duration-200 ${
              isNearLimit ? 'bg-teal-500' : 'bg-teal-500'
            }`}
            style={{ width: `${percentage}%` }}
          />
        </div>
      )}
    </div>
  );
};

export default CountingInput;