import React from 'react';

interface TextareaInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  rows?: number;
  maxLength?: number;
}

export default function TextareaInput({
  value,
  onChange,
  placeholder = 'Enter your message...',
  rows = 4,
  maxLength
}: TextareaInputProps) {
  return (
    <div className="w-full">
      <textarea
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        rows={rows}
        maxLength={maxLength}
        className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all resize-y"
      />
      {maxLength && (
        <div className="flex justify-end mt-1 px-1">
          <span className="text-sm text-gray-500">
            {value.length} / {maxLength}
          </span>
        </div>
      )}
    </div>
  );
}
