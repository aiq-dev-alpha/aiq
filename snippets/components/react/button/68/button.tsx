import React from 'react';

interface ParticleButton1Props extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
}

export const ParticleButton1: React.FC<ParticleButton1Props> = ({
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

export default ParticleButton1;