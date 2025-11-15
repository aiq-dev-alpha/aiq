import React, { useState } from 'react';

interface InlineEditInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export default function InlineEditInput({
  value,
  onChange,
  placeholder = 'Click to edit...'
}: InlineEditInputProps) {
  const [isEditing, setIsEditing] = useState(false);

  const handleBlur = () => {
    setIsEditing(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      setIsEditing(false);
    } else if (e.key === 'Escape') {
      setIsEditing(false);
    }
  };

  if (isEditing) {
    return (
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        onBlur={handleBlur}
        onKeyDown={handleKeyDown}
        autoFocus
        className="w-full px-2 py-1 text-base border-2 border-blue-500 rounded focus:outline-none"
      />
    );
  }

  return (
    <div
      onClick={() => setIsEditing(true)}
      className="w-full px-2 py-1 text-base cursor-text hover:bg-gray-50 rounded transition-colors min-h-[34px] flex items-center"
    >
      {value || <span className="text-gray-400">{placeholder}</span>}
    </div>
  );
}
