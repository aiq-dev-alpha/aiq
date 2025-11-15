import React, { useState } from 'react';

interface UnderlineInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function UnderlineInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: UnderlineInputProps) {
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
        className="w-full px-2 py-2 text-base bg-transparent border-b-2 border-gray-300 outline-none transition-colors duration-300 focus:border-blue-500"
      />
      <div
        className={`absolute bottom-0 left-0 h-0.5 bg-blue-500 transition-all duration-300 ${
          isFocused ? 'w-full' : 'w-0'
        }`}
      />
    </div>
  );
}
