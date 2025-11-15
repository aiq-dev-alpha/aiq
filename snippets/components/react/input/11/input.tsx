import React from 'react';

interface CharacterCounterInputProps {
  value: string;
  onChange: (value: string) => void;
  maxLength: number;
  placeholder?: string;
  type?: string;
}

export default function CharacterCounterInput({
  value,
  onChange,
  maxLength,
  placeholder = 'Enter text...',
  type = 'text'
}: CharacterCounterInputProps) {
  const remaining = maxLength - value.length;
  const isNearLimit = remaining <= maxLength * 0.2;

  return (
    <div className="w-full">
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value.slice(0, maxLength))}
        placeholder={placeholder}
        maxLength={maxLength}
        className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      <div className="flex justify-end mt-1 px-1">
        <span className={`text-sm ${isNearLimit ? 'text-orange-500' : 'text-gray-500'}`}>
          {value.length} / {maxLength}
        </span>
      </div>
    </div>
  );
}
