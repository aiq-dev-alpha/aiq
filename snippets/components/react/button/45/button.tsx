import React, { useState } from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  color?: 'red' | 'blue' | 'green' | 'orange';
  depth?: number;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  color = 'blue',
  depth = 6
}) => {
  const [isPressed, setIsPressed] = useState(false);

  const colors = {
    red: { top: '#e74c3c', bottom: '#c0392b' },
    blue: { top: '#3498db', bottom: '#2980b9' },
    green: { top: '#2ecc71', bottom: '#27ae60' },
    orange: { top: '#e67e22', bottom: '#d35400' }
  };

  const currentColor = colors[color];

  return (
    <button
      onClick={onClick}
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      onMouseLeave={() => setIsPressed(false)}
      style={{
        padding: '14px 28px',
        background: currentColor.top,
        border: 'none',
        borderRadius: '10px',
        color: '#fff',
        fontSize: '16px',
        fontWeight: 'bold',
        cursor: 'pointer',
        position: 'relative',
        transform: isPressed ? `translateY(${depth}px)` : 'translateY(0)',
        boxShadow: isPressed
          ? '0 0 0 rgba(0,0,0,0.2)'
          : `0 ${depth}px 0 ${currentColor.bottom}`,
        transition: 'all 0.1s ease'
      }}
    >
      {children}
    </button>
  );
};
