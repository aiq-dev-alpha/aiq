import React from 'react';

interface MaskedInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export default function MaskedInput({
  value,
  onChange,
  placeholder = '(555) 555-5555'
}: MaskedInputProps) {
  const formatPhoneNumber = (input: string) => {
    const cleaned = input.replace(/\D/g, '');
    const limited = cleaned.slice(0, 10);

    if (limited.length <= 3) {
      return limited;
    } else if (limited.length <= 6) {
      return `(${limited.slice(0, 3)}) ${limited.slice(3)}`;
    } else {
      return `(${limited.slice(0, 3)}) ${limited.slice(3, 6)}-${limited.slice(6)}`;
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatPhoneNumber(e.target.value);
    onChange(formatted);
  };

  return (
    <input
      type="text"
      value={value}
      onChange={handleChange}
      placeholder={placeholder}
      className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
    />
  );
}
