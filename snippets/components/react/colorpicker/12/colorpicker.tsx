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
  const baseClasses = 'rounded-lg font-medium transition-transform duration-200 focus:outline-none focus:ring-2 focus:ring-teal-500';
  
  const variantClasses = {
    solid: 'bg-teal-500 text-white hover:brightness-110 hover:-translate-y-0.5 shadow-2xl',
    outline: 'border-2 border-teal-500 text-teal-600 hover:bg-teal-50',
    ghost: 'text-teal-600 hover:bg-teal-100'
  };
  
  const sizeClasses = {
    sm: 'px-2 py-1 text-xs',
    md: 'px-5 py-2.5 text-sm',
    lg: 'px-6 py-3 text-lg'
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
