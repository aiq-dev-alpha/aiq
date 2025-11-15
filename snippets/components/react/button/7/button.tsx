import React, { useState, useRef, useEffect } from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  className?: string;
  children: React.ReactNode;
  onClick?: (e: React.MouseEvent<HTMLButtonElement>) => void;
  variant?: 'elevated' | 'tonal' | 'outlined' | 'text';
  size?: 'compact' | 'standard' | 'large';
  disabled?: boolean;
  loading?: boolean;
  icon?: React.ReactNode;
  trailingIcon?: React.ReactNode;
  fullWidth?: boolean;
  ripple?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  variant = 'elevated',
  size = 'standard',
  disabled = false,
  loading = false,
  icon,
  trailingIcon,
  fullWidth = false,
  ripple = true
}) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);
  const buttonRef = useRef<HTMLButtonElement>(null);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (ripple && !disabled && !loading) {
      const button = buttonRef.current;
      if (button) {
        const rect = button.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const id = Date.now();
        setRipples(prev => [...prev, { x, y, id }]);
        setTimeout(() => setRipples(prev => prev.filter(r => r.id !== id)), 600);
      }
    }
    onClick?.(e);
  };

  const variantStyles = {
    elevated: 'bg-indigo-500 text-white shadow-md hover:shadow-lg hover:bg-indigo-600',
    tonal: 'bg-indigo-100 text-indigo-900 hover:bg-indigo-200 hover:shadow-sm',
    outlined: 'bg-transparent text-indigo-600 border-2 border-indigo-600 hover:bg-indigo-50',
    text: 'bg-transparent text-indigo-600 hover:bg-indigo-50'
  };

  const sizeStyles = {
    compact: 'px-4 py-1.5 text-sm min-h-[32px]',
    standard: 'px-6 py-2.5 text-base min-h-[40px]',
    large: 'px-8 py-3.5 text-lg min-h-[48px]'
  };

  return (
    <button
      ref={buttonRef}
      onClick={handleClick}
      disabled={disabled || loading}
      className={`
        ${variantStyles[variant]}
        ${sizeStyles[size]}
        ${fullWidth ? 'w-full' : ''}
        rounded-xl font-semibold
        transition-all duration-200 ease-in-out
        transform active:scale-95
        disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none
        focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:ring-offset-2
        inline-flex items-center justify-center gap-2
        relative overflow-hidden
        select-none
      `}
     {...props}>
      {ripples.map(({ x, y, id }) => (
        <span
          key={id}
          className="absolute bg-white/30 rounded-full pointer-events-none animate-ping"
          style={{
            left: x,
            top: y,
            width: 10,
            height: 10,
            transform: 'translate(-50%, -50%)'
          }}
        />
      ))}

      {loading ? (
        <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24" fill="none">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
        </svg>
      ) : (
        <>
          {icon && <span className="inline-flex items-center">{icon}</span>}
          <span>{children}</span>
          {trailingIcon && <span className="inline-flex items-center">{trailingIcon}</span>}
        </>
      )}
    </button>
  );
};

export default Button;