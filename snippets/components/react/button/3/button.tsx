import React from 'react';
import './button.css';

// Version 3: Glassmorphism style buttons

export type ButtonVariant = 'primary' | 'secondary' | 'success' | 'danger' | 'warning' | 'info';
export type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  fullWidth?: boolean;
  loading?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
}

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  loading = false,
  icon,
  iconPosition = 'left',
  className = '',
  disabled,
  ...props
}) => {
  const classes = [
    'btn-v3',
    `btn-v3-${variant}`,
    `btn-v3-${size}`,
    fullWidth ? 'btn-v3-full' : '',
    loading ? 'btn-v3-loading' : '',
    className
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classes}
      disabled={disabled || loading}
      {...props}
    >
      <span className="btn-v3-bg" />
      <span className="btn-v3-content">
        {loading && (
          <span className="btn-v3-spinner" />
        )}
        {!loading && icon && iconPosition === 'left' && (
          <span className="btn-v3-icon">{icon}</span>
        )}
        {!loading && <span>{children}</span>}
        {!loading && icon && iconPosition === 'right' && (
          <span className="btn-v3-icon">{icon}</span>
        )}
      </span>
    </button>
  );
};
