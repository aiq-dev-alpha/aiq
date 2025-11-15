import React, { useState } from 'react';

interface GradientBorderInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function GradientBorderInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: GradientBorderInputProps) {
  const [isFocused, setIsFocused] = useState(false);

  return (
    <div className="relative w-full p-0.5 rounded-lg bg-gradient-to-r from-purple-500 via-pink-500 to-blue-500">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onFocus={() => setIsFocused(true)}
        onBlur={() => setIsFocused(false)}
        placeholder={placeholder}
        className={`w-full px-4 py-2.5 text-base bg-white rounded-lg outline-none transition-all duration-300 ${
          isFocused ? 'shadow-lg' : ''
        }`}
      />
    </div>
  );
}
