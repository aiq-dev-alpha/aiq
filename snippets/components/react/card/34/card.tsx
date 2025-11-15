import React from 'react';

interface CardProps {
  children: React.ReactNode;
  gradient?: 'rainbow' | 'sunset' | 'ocean' | 'forest';
  borderWidth?: number;
  padding?: number;
}

export const Card: React.FC<CardProps> = ({
  children,
  gradient = 'rainbow',
  borderWidth = 2,
  padding = 24
}) => {
  const gradients = {
    rainbow: 'linear-gradient(90deg, #ff0080, #ff8c00, #40e0d0, #ff0080)',
    sunset: 'linear-gradient(90deg, #f093fb 0%, #f5576c 100%)',
    ocean: 'linear-gradient(90deg, #4facfe 0%, #00f2fe 100%)',
    forest: 'linear-gradient(90deg, #43e97b 0%, #38f9d7 100%)'
  };

  return (
    <div
      style={{
        background: gradients[gradient],
        backgroundSize: '200% 200%',
        animation: 'gradientRotate 4s linear infinite',
        padding: borderWidth,
        borderRadius: '16px',
        maxWidth: '500px'
      }}
    >
      <div
        style={{
          background: '#fff',
          borderRadius: `${16 - borderWidth}px`,
          padding: padding
        }}
      >
        {children}
      </div>
      <style>{`
        @keyframes gradientRotate {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }
      `}</style>
    </div>
  );
};
