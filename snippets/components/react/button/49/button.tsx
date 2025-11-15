import React from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  gradient?: 'sunset' | 'ocean' | 'forest' | 'purple';
  animated?: boolean;
  size?: 'sm' | 'md' | 'lg';
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  gradient = 'sunset',
  animated = true,
  size = 'md'
}) => {
  const gradients = {
    sunset: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
    ocean: 'linear-gradient(135deg, #0093E9 0%, #80D0C7 100%)',
    forest: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)',
    purple: 'linear-gradient(135deg, #A8EDEA 0%, #FED6E3 100%)'
  };

  const sizes = {
    sm: { padding: '10px 20px', fontSize: '14px' },
    md: { padding: '14px 28px', fontSize: '16px' },
    lg: { padding: '18px 36px', fontSize: '18px' }
  };

  return (
    <button
      onClick={onClick}
      style={{
        ...sizes[size],
        background: gradients[gradient],
        backgroundSize: animated ? '200% 200%' : '100% 100%',
        animation: animated ? 'gradientShift 3s ease infinite' : 'none',
        border: 'none',
        borderRadius: '50px',
        color: '#fff',
        fontWeight: 'bold',
        cursor: 'pointer',
        boxShadow: '0 4px 15px 0 rgba(0, 0, 0, 0.2)',
        transition: 'all 0.3s ease',
        position: 'relative',
        overflow: 'hidden'
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.transform = 'translateY(-2px)';
        e.currentTarget.style.boxShadow = '0 6px 20px 0 rgba(0, 0, 0, 0.3)';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'translateY(0)';
        e.currentTarget.style.boxShadow = '0 4px 15px 0 rgba(0, 0, 0, 0.2)';
      }}
    >
      {children}
      <style>{`
        @keyframes gradientShift {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }
      `}</style>
    </button>
  );
};
