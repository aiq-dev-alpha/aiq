import React from 'react';

interface SliderInputProps {
  value: number;
  onChange: (value: number) => void;
  min?: number;
  max?: number;
  step?: number;
  label?: string;
}

export default function SliderInput({
  value,
  onChange,
  min = 0,
  max = 100,
  step = 1,
  label = 'Value'
}: SliderInputProps) {
  const percentage = ((value - min) / (max - min)) * 100;

  return (
    <div className="w-full">
      <div className="flex justify-between items-center mb-2">
        <label className="text-sm font-medium text-gray-700">{label}</label>
        <span className="text-sm font-semibold text-blue-600">{value}</span>
      </div>
      <div className="relative">
        <input
          type="range"
          min={min}
          max={max}
          step={step}
          value={value}
          onChange={(e) => onChange(Number(e.target.value))}
          className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
          style={{
            background: `linear-gradient(to right, #3b82f6 0%, #3b82f6 ${percentage}%, #e5e7eb ${percentage}%, #e5e7eb 100%)`
          }}
        />
      </div>
      <div className="flex justify-between mt-1">
        <span className="text-xs text-gray-500">{min}</span>
        <span className="text-xs text-gray-500">{max}</span>
      </div>
    </div>
  );
}
