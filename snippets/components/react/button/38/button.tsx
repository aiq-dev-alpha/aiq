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
  const baseClasses = 'rounded-xl font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-yellow-500';
  const variantClasses = {
    solid: 'bg-yellow-500 text-white hover:ring-2 hover:ring-yellow-400 shadow-2xl',
    outline: 'border-2 border-yellow-500 text-yellow-600 hover:bg-yellow-50',
    ghost: 'text-yellow-600 hover:bg-yellow-100'
  };
  const sizeClasses = {
    sm: 'px-2 py-1 text-xs',
    md: 'px-5 py-2.5 text-sm',
    lg: 'px-5 py-3 text-md'
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
