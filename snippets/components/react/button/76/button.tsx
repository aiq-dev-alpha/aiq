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
  const baseClasses = 'rounded-xl font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-pink-500';
  
  const variantClasses = {
    solid: 'bg-pink-500 text-white hover:bg-pink-600 hover:shadow-lg shadow-lg',
    outline: 'border-2 border-pink-500 text-pink-600 hover:bg-pink-50',
    ghost: 'text-pink-600 hover:bg-pink-100'
  };
  
  const sizeClasses = {
    sm: 'px-2.5 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
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
