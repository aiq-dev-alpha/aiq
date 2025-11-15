import React, { useEffect, useRef } from 'react';

interface AutogrowInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  minHeight?: number;
}

export default function AutogrowInput({
  value,
  onChange,
  placeholder = 'Enter text...',
  minHeight = 42
}: AutogrowInputProps) {
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto';
      textareaRef.current.style.height = `${Math.max(
        textareaRef.current.scrollHeight,
        minHeight
      )}px`;
    }
  }, [value, minHeight]);

  return (
    <textarea
      ref={textareaRef}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      rows={1}
      style={{ minHeight: `${minHeight}px` }}
      className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all resize-none overflow-hidden"
    />
  );
}
