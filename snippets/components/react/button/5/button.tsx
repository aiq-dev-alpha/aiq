import React from 'react';

interface OutlineAnimatedButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  borderColor?: string;
}

export const OutlineAnimatedButton: React.FC<OutlineAnimatedButtonProps> = ({
  children,
  borderColor = 'blue',
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        relative px-6 py-3
        border-2 border-${borderColor}-600
        text-${borderColor}-600
        font-semibold rounded-lg
        overflow-hidden
        transition-all duration-300
        hover:text-white
        before:content-[''] before:absolute before:inset-0
        before:bg-${borderColor}-600 before:translate-y-full
        before:transition-transform before:duration-300
        hover:before:translate-y-0
        $${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      <span className="relative z-10">{children}</span>
    </button>
  );
};

export default OutlineAnimatedButton;