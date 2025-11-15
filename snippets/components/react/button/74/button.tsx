import React from 'react';

interface WaveButton0Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const WaveButton0: React.FC<WaveButton0Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-blue-600 hover:bg-blue-700
        text-white font-medium
        transition-all duration-200
        hover:scale-105
        active:scale-95
        shadow-sm
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default WaveButton0;