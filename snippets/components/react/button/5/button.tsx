import React, { useState } from 'react';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  neonColor?: 'cyan' | 'pink' | 'green' | 'yellow';
  intensity?: 'low' | 'medium' | 'high';
}

export const Button: React.FC<ButtonProps> = ({
  children,
  onClick,
  neonColor = 'cyan',
  intensity = 'medium'
}) => {
  const [isGlowing, setIsGlowing] = useState(false);

  const colors = {
    cyan: { main: '#00f0ff', shadow: 'rgba(0, 240, 255, 0.5)' },
    pink: { main: '#ff00ff', shadow: 'rgba(255, 0, 255, 0.5)' },
    green: { main: '#00ff00', shadow: 'rgba(0, 255, 0, 0.5)' },
    yellow: { main: '#ffff00', shadow: 'rgba(255, 255, 0, 0.5)' }
  };

  const intensityMap = {
    low: '0 0 5px',
    medium: '0 0 10px',
    high: '0 0 20px'
  };

  const color = colors[neonColor];

  return (
    <button
      onClick={onClick}
      onMouseEnter={() => setIsGlowing(true)}
      onMouseLeave={() => setIsGlowing(false)}
      style={{
        padding: '12px 30px',
        background: '#1a1a2e',
        border: `2px solid ${color.main}`,
        borderRadius: '4px',
        color: color.main,
        fontSize: '16px',
        fontWeight: 'bold',
        textTransform: 'uppercase',
        cursor: 'pointer',
        letterSpacing: '2px',
        position: 'relative',
        transition: 'all 0.3s ease',
        boxShadow: isGlowing
          ? `${intensityMap[intensity]} ${color.shadow}, inset ${intensityMap[intensity]} ${color.shadow}`
          : 'none',
        textShadow: isGlowing ? `0 0 10px ${color.main}` : 'none'
      }}
    >
      {children}
      {isGlowing && (
        <span
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            background: color.shadow,
            filter: 'blur(8px)',
            opacity: 0.3,
            zIndex: -1
          }}
        />
      )}
    </button>
  );
};
