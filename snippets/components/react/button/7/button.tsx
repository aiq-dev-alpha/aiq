import React from 'react';

interface RippleButton1Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const RippleButton1: React.FC<RippleButton1Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-green-600 hover:bg-green-700
        text-white font-medium
        transition-all duration-250
        hover:scale-106
        active:scale-96
        shadow-md
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default RippleButton1;