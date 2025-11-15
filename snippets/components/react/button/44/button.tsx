import React from 'react';

interface RotateButton6Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const RotateButton6: React.FC<RotateButton6Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-pink-600 hover:bg-pink-700
        text-white font-medium
        transition-all duration-500
        hover:scale-111
        active:scale-101
        shadow-lg
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default RotateButton6;