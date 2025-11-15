import React, { useState, useMemo } from 'react';

interface ButtonTheme {
  background: string;
  text: string;
  border?: string;
  hover: string;
  active: string;
}

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  theme?: 'primary' | 'success' | 'warning' | 'danger' | 'neutral';
  appearance?: 'filled' | 'outlined' | 'ghost' | 'gradient';
  dimension?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  disabled?: boolean;
  processing?: boolean;
  prefixIcon?: string;
  suffixIcon?: string;
  rounded?: 'none' | 'sm' | 'md' | 'lg' | 'full';
  block?: boolean;
  animated?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  theme = 'primary',
  appearance = 'filled',
  dimension = 'md',
  disabled = false,
  processing = false,
  prefixIcon,
  suffixIcon,
  rounded = 'md',
  block = false,
  animated = true
}) => {
  const [isPressed, setIsPressed] = useState(false);

  const themes: Record<string, ButtonTheme> = {
    primary: {
      background: 'bg-blue-600',
      text: 'text-white',
      hover: 'hover:bg-blue-700',
      active: 'active:bg-blue-800'
    },
    success: {
      background: 'bg-green-600',
      text: 'text-white',
      hover: 'hover:bg-green-700',
      active: 'active:bg-green-800'
    },
    warning: {
      background: 'bg-amber-500',
      text: 'text-white',
      hover: 'hover:bg-amber-600',
      active: 'active:bg-amber-700'
    },
    danger: {
      background: 'bg-red-600',
      text: 'text-white',
      hover: 'hover:bg-red-700',
      active: 'active:bg-red-800'
    },
    neutral: {
      background: 'bg-gray-200',
      text: 'text-gray-900',
      hover: 'hover:bg-gray-300',
      active: 'active:bg-gray-400'
    }
  };

  const dimensions = {
    xs: 'px-2 py-1 text-xs gap-1',
    sm: 'px-3 py-1.5 text-sm gap-1.5',
    md: 'px-4 py-2 text-base gap-2',
    lg: 'px-6 py-3 text-lg gap-2.5',
    xl: 'px-8 py-4 text-xl gap-3'
  };

  const roundedStyles = {
    none: 'rounded-none',
    sm: 'rounded-sm',
    md: 'rounded-md',
    lg: 'rounded-lg',
    full: 'rounded-full'
  };

  const themeStyle = themes[theme];

  const getAppearanceClass = () => {
    switch (appearance) {
      case 'filled':
        return `${themeStyle.background} ${themeStyle.text} ${themeStyle.hover} ${themeStyle.active}`;
      case 'outlined':
        return `bg-transparent border-2 border-current ${themeStyle.text.replace('text-white', `text-${theme}-600`)} hover:bg-opacity-10 hover:bg-current`;
      case 'ghost':
        return `bg-transparent ${themeStyle.text.replace('text-white', `text-${theme}-600`)} hover:bg-opacity-10 hover:bg-current`;
      case 'gradient':
        return `bg-gradient-to-r from-${theme}-500 to-${theme}-700 text-white hover:from-${theme}-600 hover:to-${theme}-800`;
      default:
        return '';
    }
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled || processing}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      onMouseLeave={() => setIsPressed(false)}
      className={`
        ${getAppearanceClass()}
        ${dimensions[dimension]}
        ${roundedStyles[rounded]}
        ${block ? 'w-full' : ''}
        ${animated ? 'transition-all duration-200' : ''}
        ${isPressed && animated ? 'scale-95' : ''}
        ${disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}
        font-semibold
        inline-flex items-center justify-center
        focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-${theme}-500
        shadow-sm hover:shadow-md
      `}
    >
      {processing ? (
        <span className="inline-flex gap-1">
          <span className="w-1.5 h-1.5 bg-current rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
          <span className="w-1.5 h-1.5 bg-current rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
          <span className="w-1.5 h-1.5 bg-current rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
        </span>
      ) : (
        <>
          {prefixIcon && <span>{prefixIcon}</span>}
          {children}
          {suffixIcon && <span>{suffixIcon}</span>}
        </>
      )}
    </button>
  );
};
