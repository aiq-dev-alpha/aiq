import React, { useState } from 'react';

interface CardProps {
  className?: string;
  title: string;
  description?: string;
  image?: string;
  footer?: React.ReactNode;
  onClick?: () => void;
  elevation?: 'low' | 'medium' | 'high';
}

export const Card: React.FC<CardProps> = ({
  title,
  description,
  image,
  footer,
  onClick,
  elevation = 'medium'
}) => {
  const [isHovered, setIsHovered] = useState(false);

  const elevations = {
    low: { default: '0 1px 3px rgba(0,0,0,0.12)', hover: '0 4px 6px rgba(0,0,0,0.15)' },
    medium: { default: '0 4px 6px rgba(0,0,0,0.1)', hover: '0 10px 15px rgba(0,0,0,0.2)' },
    high: { default: '0 10px 20px rgba(0,0,0,0.15)', hover: '0 15px 30px rgba(0,0,0,0.25)' }
  };

  return (
    <div
      onClick={onClick}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      style={{
        background: '#fff',
        borderRadius: '12px',
        overflow: 'hidden',
        cursor: onClick ? 'pointer' : 'default',
        transform: isHovered ? 'translateY(-8px)' : 'translateY(0)',
        boxShadow: isHovered ? elevations[elevation].hover : elevations[elevation].default,
        transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
        maxWidth: '400px'
      }}
    >
      {image && (
        <div style={{ width: '100%', height: '200px', overflow: 'hidden' }}>
          <img
            src={image}
            alt={title}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              transform: isHovered ? 'scale(1.05)' : 'scale(1)',
              transition: 'transform 0.3s ease'
            }}
          />
        </div>
      )}
      <div style={{ padding: '20px' }}>
        <h3 style={{ margin: '0 0 12px 0', fontSize: '20px', fontWeight: '600', color: '#1a1a1a' }}>
          {title}
        </h3>
        {description && (
          <p style={{ margin: 0, fontSize: '14px', color: '#666', lineHeight: '1.5' }}>
            {description}
          </p>
        )}
      </div>
      {footer && (
        <div style={{ padding: '12px 20px', borderTop: '1px solid #e5e5e5', background: '#fafafa' }}>
          {footer}
        </div>
      )}
    </div>
  );
};

export default Card;