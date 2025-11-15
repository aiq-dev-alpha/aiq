import React, { useState } from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'glass' | 'frosted';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  variant = 'glass',
  size = 'md',
  disabled = false
}) => {
  const [ripples, setRipples] = useState<Array<{ x: number; y: number; id: number }>>([]);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    setRipples([...ripples, { x, y, id: Date.now() }]);
    setTimeout(() => setRipples(r => r.slice(1)), 600);
    onClick?.();
  };

  const sizeStyles = {
    sm: { padding: '8px 16px', fontSize: '14px' },
    md: { padding: '12px 24px', fontSize: '16px' },
    lg: { padding: '16px 32px', fontSize: '18px' }
  };

  const variantStyles = {
    glass: {
      background: 'rgba(255, 255, 255, 0.1)',
      backdropFilter: 'blur(10px)',
      border: '1px solid rgba(255, 255, 255, 0.2)',
    },
    frosted: {
      background: 'rgba(255, 255, 255, 0.05)',
      backdropFilter: 'blur(20px) saturate(180%)',
      border: '1px solid rgba(255, 255, 255, 0.3)',
    }
  };

  return (
    <button
      onClick={handleClick}
      disabled={disabled}
      style={{
        ...sizeStyles[size],
        ...variantStyles[variant],
        position: 'relative',
        overflow: 'hidden',
        borderRadius: '12px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        opacity: disabled ? 0.5 : 1,
        transition: 'all 0.3s ease',
        color: '#fff',
        fontWeight: 600,
        boxShadow: '0 8px 32px 0 rgba(31, 38, 135, 0.37)'
      }}
    >
      {children}
      {ripples.map(ripple => (
        <span
          key={ripple.id}
          style={{
            position: 'absolute',
            left: ripple.x,
            top: ripple.y,
            width: 0,
            height: 0,
            borderRadius: '50%',
            background: 'rgba(255, 255, 255, 0.6)',
            transform: 'translate(-50%, -50%)',
            animation: 'ripple 0.6s ease-out'
          }}
        />
      ))}
      <style>{`
        @keyframes ripple {
          to {
            width: 200px;
            height: 200px;
            opacity: 0;
          }
        }
      `}</style>
    </button>
  );
};
