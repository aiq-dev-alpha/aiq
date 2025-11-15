import React from 'react';

interface GlassmorphismInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function GlassmorphismInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: GlassmorphismInputProps) {
  return (
    <div className="w-full backdrop-blur-xl bg-white/20 border border-white/30 rounded-lg shadow-xl">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full px-4 py-2.5 text-base bg-transparent outline-none placeholder-white/60 text-gray-800"
      />
    </div>
  );
}
