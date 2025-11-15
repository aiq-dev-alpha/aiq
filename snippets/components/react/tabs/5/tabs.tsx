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
  const baseClasses = 'rounded-lg font-medium transition-transform duration-200 focus:outline-none focus:ring-2 focus:ring-amber-500';
  const variantClasses = {
    solid: 'bg-amber-500 text-white hover:opacity-90 active:scale-95 shadow-2xl',
    outline: 'border-2 border-amber-500 text-amber-600 hover:bg-amber-50',
    ghost: 'text-amber-600 hover:bg-amber-100'
  };
  const sizeClasses = {
    sm: 'px-3 py-1 text-xs',
    md: 'px-3.5 py-2 text-sm',
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