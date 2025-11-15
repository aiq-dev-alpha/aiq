import React from 'react';

interface DateInputProps {
  value: string;
  onChange: (value: string) => void;
  label?: string;
}

export default function DateInput({
  value,
  onChange,
  label = 'Date'
}: DateInputProps) {
  return (
    <div className="w-full">
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <div className="relative">
        <input
          type="date"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="w-full pl-4 pr-10 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
        />
        <div className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>
      </div>
    </div>
  );
}
