import React from 'react';

interface IconInputRightProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  onSearch?: () => void;
}

export default function IconInputRight({
  value,
  onChange,
  placeholder = 'Search...',
  onSearch
}: IconInputRightProps) {
  return (
    <div className="relative w-full">
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && onSearch?.()}
        placeholder={placeholder}
        className="w-full pl-4 pr-10 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      <button
        onClick={onSearch}
        className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-blue-500 transition-colors"
      >
        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </button>
    </div>
  );
}
