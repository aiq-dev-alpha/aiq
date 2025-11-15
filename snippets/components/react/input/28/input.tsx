import React, { useState, DragEvent } from 'react';

interface FileInputProps {
  onFileSelect: (file: File | null) => void;
  accept?: string;
}

export default function FileInput({
  onFileSelect,
  accept = '*'
}: FileInputProps) {
  const [isDragging, setIsDragging] = useState(false);
  const [fileName, setFileName] = useState<string>('');

  const handleDragOver = (e: DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = () => {
    setIsDragging(false);
  };

  const handleDrop = (e: DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setIsDragging(false);
    const file = e.dataTransfer.files[0];
    if (file) {
      setFileName(file.name);
      onFileSelect(file);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0] || null;
    if (file) {
      setFileName(file.name);
      onFileSelect(file);
    }
  };

  return (
    <div
      onDragOver={handleDragOver}
      onDragLeave={handleDragLeave}
      onDrop={handleDrop}
      className={`relative w-full p-8 border-2 border-dashed rounded-lg transition-all ${
        isDragging
          ? 'border-blue-500 bg-blue-50'
          : 'border-gray-300 hover:border-gray-400'
      }`}
    >
      <input
        type="file"
        onChange={handleFileChange}
        accept={accept}
        className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
      />
      <div className="text-center">
        <svg className="mx-auto w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
        </svg>
        <p className="mt-2 text-sm text-gray-600">
          {fileName || 'Drag and drop your file here, or click to browse'}
        </p>
      </div>
    </div>
  );
}
