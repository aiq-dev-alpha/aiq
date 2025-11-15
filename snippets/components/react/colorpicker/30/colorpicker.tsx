import React, { useState } from 'react';
interface ColorPickerProps {
  value?: string;
  onChange?: (color: string) => void;
  presets?: string[];
}
export const ColorPicker: React.FC<ColorPickerProps> = ({
  value = '#3b82f6',
  onChange,
  presets = ['#ef4444', '#f59e0b', '#10b981', '#3b82f6', '#8b5cf6', '#ec4899']
}) => {
  const [color, setColor] = useState(value);
  const [isOpen, setIsOpen] = useState(false);
  const handleColorChange = (newColor: string) => {
    setColor(newColor);
    onChange?.(newColor);
  };
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 px-3 py-2 border border-gray-300 rounded-lg bg-white hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        <div
          className="w-6 h-6 rounded border border-gray-300"
          style={{ backgroundColor: color }}
        />
        <span className="text-sm font-mono text-gray-700">{color}</span>
      </button>
      {isOpen && (
        <div className="absolute top-full mt-2 bg-white border border-gray-200 rounded-lg shadow-xl p-4 z-10">
          <div className="mb-3">
            <input
              type="color"
              value={color}
              onChange={(e) => handleColorChange(e.target.value)}
              className="w-full h-32 rounded cursor-pointer"
            />
          </div>
          <div className="grid grid-cols-6 gap-2">
            {presets.map(preset => (
              <button
                key={preset}
                onClick={() => handleColorChange(preset)}
                className="w-8 h-8 rounded border-2 border-transparent hover:border-gray-400 transition-colors"
                style={{ backgroundColor: preset }}
              />
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
