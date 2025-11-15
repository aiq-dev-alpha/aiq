import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  icon: React.ReactNode;
  label?: string;
  rounded?: boolean;
  size?: number;
}

export const Button: React.FC<ButtonProps> = ({
  icon,
  label,
  rounded = false,
  size = 40,
  className = '',
  ...props
}) => {
  return (
    <button
      onClick={(e) => { const ripple = document.createElement("span"); ripple.className = "absolute inset-0 bg-white opacity-25 animate-ping"; e.currentTarget.appendChild(ripple); setTimeout(() => ripple.remove(), 600); onClick?.(e); }}
      className={`inline-flex items-center justify-center bg-gray-100 hover:bg-gray-200 text-gray-700 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 ${rounded ? 'rounded-full' : 'rounded-md'} ${className}`}
      style={{ width: size, height: size }}
      aria-label={label}
      {...props}
    >
      {icon}
    </button>
  );
};

export default Button;