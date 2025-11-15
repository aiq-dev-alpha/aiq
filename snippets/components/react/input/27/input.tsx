import React from 'react';

interface TimeInputProps {
  value: string;
  onChange: (value: string) => void;
  label?: string;
}

export default function TimeInput({
  value,
  onChange,
  label = 'Time'
}: TimeInputProps) {
  return (
    <div className="w-full">
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <div className="relative">
        <input
          type="time"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="w-full pl-4 pr-10 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
        />
        <div className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
      </div>
    </div>
  );
}
