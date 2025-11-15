import React from 'react';

interface BounceButton7Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const BounceButton7: React.FC<BounceButton7Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-indigo-600 hover:bg-indigo-700
        text-white font-medium
        transition-all duration-550
        hover:scale-112
        active:scale-102
        shadow-xl
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default BounceButton7;