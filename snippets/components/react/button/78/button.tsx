import React from 'react';

interface WaveButton4Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const WaveButton4: React.FC<WaveButton4Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-orange-600 hover:bg-orange-700
        text-white font-medium
        transition-all duration-400
        hover:scale-109
        active:scale-99
        shadow-sm
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default WaveButton4;