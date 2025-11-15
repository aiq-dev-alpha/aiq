import React from 'react';

interface NeumorphismInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function NeumorphismInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: NeumorphismInputProps) {
  return (
    <div className="w-full bg-gray-100 rounded-lg shadow-[inset_5px_5px_10px_rgba(0,0,0,0.1),inset_-5px_-5px_10px_rgba(255,255,255,0.9)]">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full px-4 py-2.5 text-base bg-transparent outline-none placeholder-gray-400 text-gray-800"
      />
    </div>
  );
}
