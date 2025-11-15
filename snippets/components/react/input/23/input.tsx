import React, { useRef, KeyboardEvent } from 'react';

interface OTPInputProps {
  value: string;
  onChange: (value: string) => void;
  length?: number;
}

export default function OTPInput({
  value,
  onChange,
  length = 6
}: OTPInputProps) {
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  const handleChange = (index: number, val: string) => {
    if (!/^\d*$/.test(val)) return;

    const newValue = value.split('');
    newValue[index] = val.slice(-1);
    onChange(newValue.join(''));

    if (val && index < length - 1) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (index: number, e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Backspace' && !value[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
  };

  return (
    <div className="flex gap-2 justify-center">
      {Array.from({ length }).map((_, index) => (
        <input
          key={index}
          ref={(el) => (inputRefs.current[index] = el)}
          type="text"
          maxLength={1}
          value={value[index] || ''}
          onChange={(e) => handleChange(index, e.target.value)}
          onKeyDown={(e) => handleKeyDown(index, e)}
          className="w-12 h-12 text-center text-xl font-semibold border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
        />
      ))}
    </div>
  );
}
