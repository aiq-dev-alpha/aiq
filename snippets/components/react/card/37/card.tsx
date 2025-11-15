import React from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'solid' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  variant = 'solid',
  size = 'md',
  disabled = false,
  loading = false
}) => {
  const baseClasses = 'rounded font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-amber-500';
  
  const variantClasses = {
    solid: 'bg-amber-500 text-white hover:opacity-90 active:scale-95 shadow-xl',
    outline: 'border-2 border-amber-500 text-amber-600 hover:bg-amber-50',
    ghost: 'text-amber-600 hover:bg-amber-100'
  };
  
  const sizeClasses = {
    sm: 'px-3 py-1 text-xs',
    md: 'px-5 py-2.5 text-sm',
    lg: 'px-7 py-3.5 text-base'
  };
  
  return (
    <button
      onClick={onClick}
      disabled={disabled || loading}
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${disabled ? 'opacity-50 cursor-not-allowed' : ''}`}
    >
      {loading && <span className="animate-spin mr-2">⏳</span>}
      {children}
    </button>
  );
};
