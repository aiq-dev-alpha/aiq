import React from 'react';

export interface ButtonTheme {
  backgroundColor: string;
  hoverColor: string;
  activeColor: string;
  textColor: string;
  shadowColor: string;
}

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'tertiary';
  size?: 'compact' | 'normal' | 'large';
  theme?: Partial<ButtonTheme>;
  icon?: React.ReactNode;
  iconOnly?: boolean;
  rounded?: boolean;
  elevated?: boolean;
}

const defaultTheme: ButtonTheme = {
  backgroundColor: '#10b981',
  hoverColor: '#059669',
  activeColor: '#047857',
  textColor: '#ffffff',
  shadowColor: 'rgba(16, 185, 129, 0.3)'
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'normal',
  theme = {},
  icon,
  iconOnly = false,
  rounded = false,
  elevated = false,
  children,
  style,
  ...props
}) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  const [isHovered, setIsHovered] = React.useState(false);
  const [isActive, setIsActive] = React.useState(false);

  const sizeMap = {
    compact: { padding: iconOnly ? '0.5rem' : '0.5rem 1rem', fontSize: '0.875rem', height: '2rem' },
    normal: { padding: iconOnly ? '0.75rem' : '0.75rem 1.5rem', fontSize: '1rem', height: '2.5rem' },
    large: { padding: iconOnly ? '1rem' : '1rem 2rem', fontSize: '1.125rem', height: '3rem' }
  };

  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '0.5rem',
    backgroundColor: isActive ? appliedTheme.activeColor : isHovered ? appliedTheme.hoverColor : appliedTheme.backgroundColor,
    color: appliedTheme.textColor,
    border: 'none',
    borderRadius: rounded ? '9999px' : '0.5rem',
    cursor: 'pointer',
    fontWeight: 500,
    transition: 'all 0.15s ease',
    boxShadow: elevated ? `0 4px 12px ${appliedTheme.shadowColor}` : 'none',
    ...sizeMap[size],
    ...style
  };

  return (
    <button
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => { setIsHovered(false); setIsActive(false); }}
      onMouseDown={() => setIsActive(true)}
      onMouseUp={() => setIsActive(false)}
      style={baseStyles}
      {...props}
    >
      {icon && <span>{icon}</span>}
      {!iconOnly && children}
    </button>
  );
};
