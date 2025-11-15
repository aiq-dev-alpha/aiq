import React from 'react';

interface MagneticButton6Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const MagneticButton6: React.FC<MagneticButton6Props> = ({
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

export default MagneticButton6;