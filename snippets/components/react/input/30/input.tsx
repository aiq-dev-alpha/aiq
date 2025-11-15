import React from 'react';

interface InputGroupProps {
  value: string;
  onChange: (value: string) => void;
  addonBefore?: React.ReactNode;
  addonAfter?: React.ReactNode;
  placeholder?: string;
  type?: string;
}

export default function InputGroup({
  value,
  onChange,
  addonBefore,
  addonAfter,
  placeholder = 'Enter text...',
  type = 'text'
}: InputGroupProps) {
  return (
    <div className="flex w-full">
      {addonBefore && (
        <div className="flex items-center px-4 bg-gray-100 border border-r-0 border-gray-300 rounded-l-lg text-gray-600">
          {addonBefore}
        </div>
      )}
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className={`flex-1 px-4 py-2.5 text-base border border-gray-300 focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all ${
          !addonBefore && !addonAfter
            ? 'rounded-lg'
            : addonBefore && addonAfter
            ? ''
            : addonBefore
            ? 'rounded-r-lg'
            : 'rounded-l-lg'
        }`}
      />
      {addonAfter && (
        <div className="flex items-center px-4 bg-gray-100 border border-l-0 border-gray-300 rounded-r-lg text-gray-600">
          {addonAfter}
        </div>
      )}
    </div>
  );
}
