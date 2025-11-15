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
  const baseClasses = 'rounded font-medium transition-transform duration-200 focus:outline-none focus:ring-2 focus:ring-red-500';
  const variantClasses = {
    solid: 'bg-red-500 text-white hover:bg-red-600 hover:shadow-lg shadow-md',
    outline: 'border-2 border-red-500 text-red-600 hover:bg-red-50',
    ghost: 'text-red-600 hover:bg-red-100'
  };
  const sizeClasses = {
    sm: 'px-3 py-1 text-xs',
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
