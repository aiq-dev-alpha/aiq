import React from 'react';
import './button.css';

// Version 2: Outlined buttons with gradient hover

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
    'btn-v2',
    `btn-v2-${variant}`,
    `btn-v2-${size}`,
    fullWidth ? 'btn-v2-full' : '',
    loading ? 'btn-v2-loading' : '',
    className
  ].filter(Boolean).join(' ');

  return (
    <button
      className={classes}
      disabled={disabled || loading}
      {...props}
    >
      <span className="btn-v2-content">
        {loading && (
          <span className="btn-v2-spinner" />
        )}
        {!loading && icon && iconPosition === 'left' && (
          <span className="btn-v2-icon">{icon}</span>
        )}
        {!loading && <span>{children}</span>}
        {!loading && icon && iconPosition === 'right' && (
          <span className="btn-v2-icon">{icon}</span>
        )}
      </span>
      <span className="btn-v2-gradient" />
    </button>
  );
};
