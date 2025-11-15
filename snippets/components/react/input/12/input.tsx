import React from 'react';

interface ValidationInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  type?: string;
  validationState?: 'success' | 'error' | 'idle';
  validationMessage?: string;
}

export default function ValidationInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  type = 'text',
  validationState = 'idle',
  validationMessage
}: ValidationInputProps) {
  const borderColor =
    validationState === 'success'
      ? 'border-green-500 ring-green-200'
      : validationState === 'error'
      ? 'border-red-500 ring-red-200'
      : 'border-gray-300 ring-blue-200';

  return (
    <div className="w-full">
      <div className="relative">
        <input
          type={type}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className={`w-full pl-4 pr-10 py-2.5 text-base border-2 rounded-lg focus:ring-2 outline-none transition-all ${borderColor}`}
        />
        {validationState !== 'idle' && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2">
            {validationState === 'success' ? (
              <svg className="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
            ) : (
              <svg className="w-5 h-5 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            )}
          </div>
        )}
      </div>
      {validationMessage && (
        <p
          className={`mt-1 text-sm px-1 ${
            validationState === 'success' ? 'text-green-600' : 'text-red-600'
          }`}
        >
          {validationMessage}
        </p>
      )}
    </div>
  );
}
