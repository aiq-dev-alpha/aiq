import React from 'react';

interface Button3DProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  color?: 'blue' | 'red' | 'green' | 'purple';
}

export const Button3D: React.FC<Button3DProps> = ({
  children,
  color = 'blue',
  disabled = false,
  ...props
}) => {
  const colors = {
    blue: 'bg-blue-500 shadow-[0_6px_0_0_#1e40af] hover:shadow-[0_4px_0_0_#1e40af] active:shadow-[0_2px_0_0_#1e40af]',
    red: 'bg-red-500 shadow-[0_6px_0_0_#991b1b] hover:shadow-[0_4px_0_0_#991b1b] active:shadow-[0_2px_0_0_#991b1b]',
    green: 'bg-green-500 shadow-[0_6px_0_0_#166534] hover:shadow-[0_4px_0_0_#166534] active:shadow-[0_2px_0_0_#166534]',
    purple: 'bg-purple-500 shadow-[0_6px_0_0_#6b21a8] hover:shadow-[0_4px_0_0_#6b21a8] active:shadow-[0_2px_0_0_#6b21a8]'
  };
  
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-lg
        text-white font-bold
        ${colors[color]}
        transition-all duration-150
        hover:translate-y-0.5
        active:translate-y-1
        $${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default Button3D;