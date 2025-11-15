import React from 'react';

interface CardProps {
  children: React.ReactNode;
  blur?: 'light' | 'medium' | 'heavy';
  opacity?: number;
  bordered?: boolean;
}

export const Card: React.FC<CardProps> = ({
  children,
  blur = 'medium',
  opacity = 0.7,
  bordered = true
}) => {
  const blurValues = {
    light: '10px',
    medium: '16px',
    heavy: '24px'
  };

  return (
    <div
      style={{
        background: `rgba(255, 255, 255, ${opacity})`,
        backdropFilter: `blur(${blurValues[blur]}) saturate(180%)`,
        WebkitBackdropFilter: `blur(${blurValues[blur]}) saturate(180%)`,
        borderRadius: '16px',
        border: bordered ? '1px solid rgba(255, 255, 255, 0.3)' : 'none',
        padding: '24px',
        boxShadow: '0 8px 32px 0 rgba(31, 38, 135, 0.37)',
        maxWidth: '500px'
      }}
    >
      {children}
    </div>
  );
};
