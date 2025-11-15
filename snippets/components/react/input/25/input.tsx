import React from 'react';

interface ColorInputProps {
  value: string;
  onChange: (value: string) => void;
  label?: string;
}

export default function ColorInput({
  value,
  onChange,
  label = 'Color'
}: ColorInputProps) {
  return (
    <div className="w-full">
      <label className="block text-sm font-medium text-gray-700 mb-2">
        {label}
      </label>
      <div className="flex items-center gap-3">
        <div className="relative">
          <input
            type="color"
            value={value}
            onChange={(e) => onChange(e.target.value)}
            className="w-12 h-12 rounded-lg cursor-pointer border-2 border-gray-300"
          />
        </div>
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="#000000"
          className="flex-1 px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all font-mono"
        />
      </div>
    </div>
  );
}
