import React from 'react';

interface PrefixInputProps {
  value: string;
  onChange: (value: string) => void;
  prefix: string;
  placeholder?: string;
  type?: string;
}

export default function PrefixInput({
  value,
  onChange,
  prefix,
  placeholder = '0.00',
  type = 'text'
}: PrefixInputProps) {
  return (
    <div className="relative w-full">
      <div className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-600 font-medium pointer-events-none">
        {prefix}
      </div>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full pl-10 pr-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
    </div>
  );
}
