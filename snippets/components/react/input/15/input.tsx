import React from 'react';

interface SuffixInputProps {
  value: string;
  onChange: (value: string) => void;
  suffix: string;
  placeholder?: string;
  type?: string;
}

export default function SuffixInput({
  value,
  onChange,
  suffix,
  placeholder = 'Enter value...',
  type = 'text'
}: SuffixInputProps) {
  return (
    <div className="relative w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full pl-4 pr-16 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      <div className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-600 font-medium pointer-events-none">
        {suffix}
      </div>
    </div>
  );
}
