import React, { useState, KeyboardEvent } from 'react';

interface TagInputProps {
  tags: string[];
  onTagsChange: (tags: string[]) => void;
  placeholder?: string;
}

export default function TagInput({
  tags,
  onTagsChange,
  placeholder = 'Add tags...'
}: TagInputProps) {
  const [input, setInput] = useState('');

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && input.trim()) {
      e.preventDefault();
      if (!tags.includes(input.trim())) {
        onTagsChange([...tags, input.trim()]);
      }
      setInput('');
    } else if (e.key === 'Backspace' && !input && tags.length > 0) {
      onTagsChange(tags.slice(0, -1));
    }
  };

  const removeTag = (index: number) => {
    onTagsChange(tags.filter((_, i) => i !== index));
  };

  return (
    <div className="w-full min-h-[42px] px-2 py-1.5 border border-gray-300 rounded-lg focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-200 transition-all">
      <div className="flex flex-wrap gap-2">
        {tags.map((tag, index) => (
          <span
            key={index}
            className="inline-flex items-center gap-1 px-2 py-1 bg-blue-500 text-white text-sm rounded-md"
          >
            {tag}
            <button
              onClick={() => removeTag(index)}
              className="hover:text-red-200 transition-colors"
            >
              <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </span>
        ))}
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder={tags.length === 0 ? placeholder : ''}
          className="flex-1 min-w-[120px] px-2 py-1 text-base outline-none"
        />
      </div>
    </div>
  );
}
