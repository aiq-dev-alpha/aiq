import React, { useState } from 'react';

interface FloatingLabelInputProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  type?: string;
  placeholder?: string;
}

export default function FloatingLabelInput({
  label,
  value,
  onChange,
  type = 'text',
  placeholder = ''
}: FloatingLabelInputProps) {
  const [isFocused, setIsFocused] = useState(false);
  const hasValue = value.length > 0;
  const isFloating = isFocused || hasValue;

  return (
    <div className="relative w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        placeholder={isFloating ? placeholder : ''}
        className="w-full px-4 pt-6 pb-2 text-base border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none transition-all duration-200"
      />
      <label
        className={`absolute left-4 transition-all duration-200 pointer-events-none ${
          isFloating
            ? 'top-1.5 text-xs text-blue-500'
            : 'top-1/2 -translate-y-1/2 text-base text-gray-500'
        }`}
      >
        {label}
      </label>
    </div>
  );
}
