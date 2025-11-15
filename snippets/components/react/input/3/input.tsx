import React from 'react';

interface IconInputProps {
  icon: React.ReactNode;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function IconInputLeft({
  icon,
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: IconInputProps) {
  return (
    <div className="relative w-full">
      <div className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
        {icon}
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
