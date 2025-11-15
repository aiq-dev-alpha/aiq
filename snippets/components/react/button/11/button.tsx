import React from 'react';

interface RippleButton5Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const RippleButton5: React.FC<RippleButton5Props> = ({
  children,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        bg-teal-600 hover:bg-teal-700
        text-white font-medium
        transition-all duration-450
        hover:scale-110
        active:scale-100
        shadow-md
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default RippleButton5;