import React from 'react';

interface FlipButton2Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const FlipButton2: React.FC<FlipButton2Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-purple-600 hover:bg-purple-700
        text-white font-medium
        transition-all duration-300
        hover:scale-107
        active:scale-97
        shadow-lg
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default FlipButton2;