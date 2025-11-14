import React from 'react';
import './button.css';

// Version 1: Solid fill buttons with hover effects

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
    'btn-v1',
    `btn-v1-${variant}`,
    `btn-v1-${size}`,
    fullWidth ? 'btn-v1-full' : '',
    loading ? 'btn-v1-loading' : '',
    className
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classes}
      disabled={disabled || loading}
      {...props}
    >
      {loading && (
        <span className="btn-v1-spinner" />
      )}
      {!loading && icon && iconPosition === 'left' && (
        <span className="btn-v1-icon">{icon}</span>
      )}
      {!loading && <span>{children}</span>}
      {!loading && icon && iconPosition === 'right' && (
        <span className="btn-v1-icon">{icon}</span>
      )}
    </button>
  );
};
