import React from 'react';

interface PillInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function PillInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: PillInputProps) {
  return (
    <div className="w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full px-6 py-2.5 text-base border border-gray-300 rounded-full focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
    </div>
  );
}
