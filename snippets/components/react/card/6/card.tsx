import React, { useState } from 'react';

interface CardProps {
  className?: string;
  front: React.ReactNode;
  back: React.ReactNode;
  width?: number;
  height?: number;
}

export const Card: React.FC<CardProps> = ({
  front,
  back,
  width = 300,
  height = 400
}) => {
  const [isFlipped, setIsFlipped] = useState(false);

  const faceStyle = {
    position: 'absolute' as const,
    width: '100%',
    height: '100%',
    backfaceVisibility: 'hidden' as const,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: '16px',
    padding: '24px',
    boxShadow: '0 4px 8px rgba(0,0,0,0.1)'
  };

  return (
    <div
      onClick={() => setIsFlipped(!isFlipped)}
      style={{
        width,
        height,
        perspective: '1000px',
        cursor: 'pointer'
      }}
    >
      <div
        style={{
          position: 'relative',
          width: '100%',
          height: '100%',
          transition: 'transform 0.6s',
          transformStyle: 'preserve-3d',
          transform: isFlipped ? 'rotateY(180deg)' : 'rotateY(0deg)'
        }}
      >
        <div style={{ ...faceStyle, background: '#fff' }}>
          {front}
        </div>
        <div
          style={{
            ...faceStyle,
            background: '#4f46e5',
            color: '#fff',
            transform: 'rotateY(180deg)'
          }}
        >
          {back}
        </div>
      </div>
    </div>
  );
};

export default Card;