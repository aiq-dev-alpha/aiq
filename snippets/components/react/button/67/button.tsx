import React from 'react';

interface ParticleButton0Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const ParticleButton0: React.FC<ParticleButton0Props> = ({
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

export default ParticleButton0;