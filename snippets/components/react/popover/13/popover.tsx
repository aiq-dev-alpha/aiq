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
  const baseClasses = 'rounded-2xl font-medium transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-teal-500';
  const variantClasses = {
    solid: 'bg-teal-500 text-white hover:bg-teal-600 hover:shadow shadow-2xl',
    outline: 'border-2 border-teal-500 text-teal-600 hover:bg-teal-50',
    ghost: 'text-teal-600 hover:bg-teal-100'
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
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} $${disabled ? 'opacity-50 cursor-not-allowed' : ''}`}
     {...props}>
      {loading && <span className="animate-spin mr-2">⏳</span>}
      {children}
    </button>
  );
};

export default Button;