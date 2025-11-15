import React, { useState } from 'react';

interface NeonButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  neonColor?: 'cyan' | 'pink' | 'green' | 'yellow';
}

export const NeonButton: React.FC<NeonButtonProps> = ({
  children,
  neonColor = 'cyan',
  disabled = false,
  ...props
}) => {
  const [isGlowing, setIsGlowing] = useState(false);
  
  const colors = {
    cyan: 'border-cyan-400 text-cyan-400 hover:shadow-[0_0_20px_rgba(34,211,238,0.5)]',
    pink: 'border-pink-400 text-pink-400 hover:shadow-[0_0_20px_rgba(244,114,182,0.5)]',
    green: 'border-green-400 text-green-400 hover:shadow-[0_0_20px_rgba(74,222,128,0.5)]',
    yellow: 'border-yellow-400 text-yellow-400 hover:shadow-[0_0_20px_rgba(250,204,21,0.5)]'
  };
  
  return (
    <button
      onMouseEnter={() => setIsGlowing(true)}
      onMouseLeave={() => setIsGlowing(false)}
      disabled={disabled}
      className={`
        px-8 py-3 bg-gray-900 border-2
        ${colors[neonColor]}
        font-bold uppercase tracking-wider
        transition-all duration-300
        $${disabled ? 'opacity-50 cursor-not-allowed' : ''}
        ${isGlowing ? 'scale-105' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default NeonButton;