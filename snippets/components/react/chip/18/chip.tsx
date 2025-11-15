import React, { useState } from 'react';
interface ChipProps {
  className?: string;
  label: string;
  options?: string[];
  activeFilters?: Set<string>;
  onFilterChange?: (filters: Set<string>) => void;
}
export const Chip: React.FC<ChipProps> = ({
  label,
  options = [],
  activeFilters: controlledFilters,
  onFilterChange
}) => {
  const [internalFilters, setInternalFilters] = useState<Set<string>>(new Set());
  const [isOpen, setIsOpen] = useState(false);
  const activeFilters = controlledFilters ?? internalFilters;
  const toggleFilter = (option: string) => {
    const newFilters = new Set(activeFilters);
    if (newFilters.has(option)) {
      newFilters.delete(option);
    } else {
      newFilters.add(option);
    }
    setInternalFilters(newFilters);
    onFilterChange?.(newFilters);
  };
  const clearAll = () => {
    setInternalFilters(new Set());
    onFilterChange?.(new Set());
  };
  return (
    <div className="relative inline-block">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-purple-100 text-purple-800 text-sm font-medium hover:bg-purple-200 transition-colors focus:outline-none focus:ring-2 focus:ring-purple-500"
      >
        {label}
        {activeFilters.size > 0 && (
          <span className="bg-purple-600 text-white text-xs rounded-full px-1.5 py-0.5 min-w-[1.25rem] text-center">
            {activeFilters.size}
          </span>
        )}
        <svg className={`w-4 h-4 transition-transform ${isOpen ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 20 20">
          <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
        </svg>
      </button>
      {isOpen && (
        <div className="absolute top-full mt-2 bg-white rounded-lg shadow-lg border border-gray-200 p-2 min-w-[200px] z-10">
          {options.map(option => (
            <label key={option} className="flex items-center gap-2 px-3 py-2 hover:bg-gray-50 rounded cursor-pointer">
              <input
                type="checkbox"
                checked={activeFilters.has(option)}
                onChange={() => toggleFilter(option)}
                className="rounded text-purple-600 focus:ring-purple-500"
              />
              <span className="text-sm text-gray-700">{option}</span>
            </label>
          ))}
          {activeFilters.size > 0 && (
            <button
              onClick={clearAll}
              className="w-full mt-2 px-3 py-1.5 text-sm text-purple-600 hover:bg-purple-50 rounded font-medium"
            >
              Clear all
            </button>
          )}
        </div>
      )}
    </div>
  );
};

export default Chip;