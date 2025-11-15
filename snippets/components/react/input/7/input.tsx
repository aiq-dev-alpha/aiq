import React, { useState } from 'react';

interface AnimatedBorderInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function AnimatedBorderInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: AnimatedBorderInputProps) {
  const [isFocused, setIsFocused] = useState(false);

  return (
    <div className="relative w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        placeholder={placeholder}
        className="w-full px-4 py-2.5 text-base border-2 border-gray-300 rounded-lg outline-none transition-all duration-300"
      />
      <div
        className={`absolute inset-0 border-2 border-blue-500 rounded-lg pointer-events-none transition-all duration-300 ${
          isFocused ? 'opacity-100 scale-100' : 'opacity-0 scale-95'
        }`}
      />
      <div
        className={`absolute bottom-0 left-1/2 -translate-x-1/2 h-0.5 bg-blue-500 transition-all duration-300 ${
          isFocused ? 'w-full' : 'w-0'
        }`}
      />
    </div>
  );
}
