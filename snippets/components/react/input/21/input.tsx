import React, { useState } from 'react';

interface AutocompleteInputProps {
  value: string;
  onChange: (value: string) => void;
  suggestions: string[];
  placeholder?: string;
}

export default function AutocompleteInput({
  value,
  onChange,
  suggestions,
  placeholder = 'Search...'
}: AutocompleteInputProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [highlightedIndex, setHighlightedIndex] = useState(0);

  const filteredSuggestions = suggestions.filter((suggestion) =>
    suggestion.toLowerCase().includes(value.toLowerCase())
  );

  const handleSelect = (suggestion: string) => {
    onChange(suggestion);
    setIsOpen(false);
  };

  return (
    <div className="relative w-full">
      <input
        type="text"
        value={value}
        onChange={(e) => {
          onChange(e.target.value);
          setIsOpen(true);
        }}
        onFocus={() => setIsOpen(true)}
        onBlur={() => setTimeout(() => setIsOpen(false), 200)}
        placeholder={placeholder}
        className="w-full px-4 py-2.5 text-base border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all"
      />
      {isOpen && filteredSuggestions.length > 0 && (
        <div className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-lg shadow-lg max-h-60 overflow-auto">
          {filteredSuggestions.map((suggestion, index) => (
            <div
              key={index}
              onMouseDown={() => handleSelect(suggestion)}
              onMouseEnter={() => setHighlightedIndex(index)}
              className={`px-4 py-2 cursor-pointer ${
                index === highlightedIndex ? 'bg-blue-50' : 'hover:bg-gray-50'
              }`}
            >
              {suggestion}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
