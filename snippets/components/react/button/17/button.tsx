import React from 'react';

interface BounceButton3Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const BounceButton3: React.FC<BounceButton3Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-red-600 hover:bg-red-700
        text-white font-medium
        transition-all duration-350
        hover:scale-108
        active:scale-98
        shadow-xl
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default BounceButton3;