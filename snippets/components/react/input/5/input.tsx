import React from 'react';

interface ClearButtonInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
}

export default function ClearButtonInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text'
}: ClearButtonInputProps) {
  const handleClear = () => {
    onChange('');
  };

  return (
    <div className="relative w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full pl-4 pr-10 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      {value && (
        <button
          onClick={handleClear}
          className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-red-500 transition-colors"
          aria-label="Clear input"
        >
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      )}
    </div>
  );
}
