import React from 'react';

interface GlassButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  children: React.ReactNode;
  variant?: 'light' | 'dark';
}

export const GlassButton: React.FC<GlassButtonProps> = ({
  children,
  variant = 'light',
  disabled = false,
  ...props
}) => {
  const variants = {
    light: 'bg-white/20 backdrop-blur-lg border-white/30 text-gray-900 hover:bg-white/30',
    dark: 'bg-black/20 backdrop-blur-lg border-white/20 text-white hover:bg-black/30'
  };
  
  return (
    <button
      disabled={disabled}
      className={`
        px-6 py-3 rounded-2xl
        border backdrop-blur-lg
        font-semibold
        ${variants[variant]}
        transition-all duration-300
        hover:scale-105
        $${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      {...props}
    >
      {children}
    </button>
  );
};

export default GlassButton;