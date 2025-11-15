import React, { useState } from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => Promise<void> | void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  variant = 'primary',
  disabled = false
}) => {
  const [isLoading, setIsLoading] = useState(false);

  const handleClick = async () => {
    if (isLoading || disabled) return;

    setIsLoading(true);
    try {
      await onClick?.();
    } finally {
      setIsLoading(false);
    }
  };

  const variants = {
    primary: { bg: '#4f46e5', hover: '#4338ca' },
    secondary: { bg: '#10b981', hover: '#059669' }
  };

  return (
    <button
      onClick={handleClick}
      disabled={disabled || isLoading}
      style={{
        padding: '12px 24px',
        background: variants[variant].bg,
        border: 'none',
        borderRadius: '8px',
        color: '#fff',
        fontSize: '16px',
        fontWeight: 600,
        cursor: (disabled || isLoading) ? 'not-allowed' : 'pointer',
        opacity: (disabled || isLoading) ? 0.7 : 1,
        transition: 'all 0.2s ease',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        minWidth: '120px',
        justifyContent: 'center'
      }}
      onMouseEnter={(e) => {
        if (!disabled && !isLoading) {
          e.currentTarget.style.background = variants[variant].hover;
        }
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.background = variants[variant].bg;
      }}
    >
      {isLoading ? (
        <>
          <div
            style={{
              width: '16px',
              height: '16px',
              border: '2px solid rgba(255,255,255,0.3)',
              borderTopColor: '#fff',
              borderRadius: '50%',
              animation: 'spin 0.6s linear infinite'
            }}
          />
          <span>Loading...</span>
          <style>{`
            @keyframes spin {
              to { transform: rotate(360deg); }
            }
          `}</style>
        </>
      ) : (
        children
      )}
    </button>
  );
};
