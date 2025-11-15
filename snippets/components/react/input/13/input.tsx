import React from 'react';

interface HelperTextInputProps {
  value: string;
  onChange: (value: string) => void;
  label: string;
  helperText: string;
  placeholder?: string;
  type?: string;
}

export default function HelperTextInput({
  value,
  onChange,
  label,
  helperText,
  placeholder = 'Enter text...',
  type = 'text'
}: HelperTextInputProps) {
  return (
    <div className="w-full">
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      <p className="mt-1 text-sm text-gray-500 px-1">{helperText}</p>
    </div>
  );
}
