import React from 'react';

interface LoadingInputProps {
  value: string;
  onChange: (value: string) => void;
  isLoading: boolean;
  placeholder?: string;
  type?: string;
}

export default function LoadingInput({
  value,
  onChange,
  isLoading,
  placeholder = 'Enter text...',
  type = 'text'
}: LoadingInputProps) {
  return (
    <div className="relative w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        disabled={isLoading}
        className="w-full pl-4 pr-10 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all disabled:bg-gray-50 disabled:cursor-not-allowed"
      />
      {isLoading && (
        <div className="absolute right-3 top-1/2 -translate-y-1/2">
          <div className="w-5 h-5 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />
        </div>
      )}
    </div>
  );
}
