import React from 'react';
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  className?: string;
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
  const baseClasses = 'rounded-lg font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500';
  const variantClasses = {
    solid: 'bg-indigo-500 text-white hover:bg-indigo-600 hover:shadow-lg shadow-2xl',
    outline: 'border-2 border-indigo-500 text-indigo-600 hover:bg-indigo-50',
    ghost: 'text-indigo-600 hover:bg-indigo-100'
  };
  const sizeClasses = {
    sm: 'px-3 py-1 text-xs',
    md: 'px-4 py-2 text-base',
    lg: 'px-5 py-3 text-md'
  };
  return (
    <button
      onClick={onClick}
      disabled={disabled || loading}
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${disabled ? 'opacity-50 cursor-not-allowed' : ''}`}
     {...props}>
      {loading && <span className="animate-spin mr-2">⏳</span>}
      {children}
    </button>
  );
};

export default Button;