import React, { useState } from 'react';
interface TextAreaProps {
  className?: string;
  value?: string;
  onChange?: (value: string) => void;
  placeholder?: string;
  maxLength?: number;
  rows?: number;
  autoResize?: boolean;
}
export const TextArea: React.FC<TextAreaProps> = ({
  value: controlledValue,
  onChange,
  placeholder,
  maxLength,
  rows = 4,
  autoResize = false
}) => {
  const [value, setValue] = useState(controlledValue || '');
  const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const newValue = e.target.value;
    setValue(newValue);
    onChange?.(newValue);
  };
  return (
    <div className="relative">
      <textarea
        value={value}
        onChange={handleChange}
        placeholder={placeholder}
        maxLength={maxLength}
        rows={rows}
        className={`w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-${autoResize ? 'none' : 'vertical'}`}
      />
      {maxLength && (
        <div className="absolute bottom-2 right-2 text-xs text-gray-500">
          {value.length}/{maxLength}
        </div>
      )}
    </div>
  );
};

export default TextArea;