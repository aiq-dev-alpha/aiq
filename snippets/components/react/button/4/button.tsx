import React from 'react';

interface NeumorphicButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  pressed?: boolean;
}

export const NeumorphicButton: React.FC<NeumorphicButtonProps> = ({
  children,
  pressed = false,
  disabled = false,
  ...props
}) => {
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-xl
        bg-gray-200 text-gray-700
        font-semibold
        transition-all duration-200
        ${pressed
          ? 'shadow-[inset_5px_5px_10px_#bebebe,inset_-5px_-5px_10px_#ffffff]'
          : 'shadow-[5px_5px_10px_#bebebe,-5px_-5px_10px_#ffffff] hover:shadow-[3px_3px_6px_#bebebe,-3px_-3px_6px_#ffffff]'
        }
        ${disabled ? 'opacity-50 cursor-not-allowed' : 'active:shadow-[inset_5px_5px_10px_#bebebe,inset_-5px_-5px_10px_#ffffff]'}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default NeumorphicButton;