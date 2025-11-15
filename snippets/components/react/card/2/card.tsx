import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({
  theme = {},
  className = '',
  onHover
}) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const handleMouseEnter = () => {
    setIsHovered(true);
    onHover?.(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
    onHover?.(false);
  };

  const containerStyles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? 'scale(1)' : 'scale(0.9)',
    transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
    borderRadius: '12px',
    overflow: 'hidden',
    cursor: 'pointer',
    position: 'relative',
    width: '300px',
    height: '400px',
    boxShadow: isHovered ? '0 12px 24px rgba(0,0,0,0.2)' : '0 4px 12px rgba(0,0,0,0.1)',
  };

  const imageStyles: React.CSSProperties = {
    width: '100%',
    height: '100%',
    objectFit: 'cover',
    transition: 'transform 350ms ease',
    transform: isHovered ? 'scale(1.1)' : 'scale(1)',
  };

  const overlayStyles: React.CSSProperties = {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    background: 'linear-gradient(to top, rgba(0,0,0,0.8), transparent)',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'flex-end',
    padding: '24px',
    opacity: isHovered ? 1 : 0,
    transition: 'opacity 350ms ease',
  };

  const titleStyles: React.CSSProperties = {
    color: '#ffffff',
    fontSize: '24px',
    fontWeight: 'bold',
    marginBottom: '8px',
    transform: isHovered ? 'translateY(0)' : 'translateY(20px)',
    transition: 'transform 350ms ease',
  };

  const descriptionStyles: React.CSSProperties = {
    color: '#e5e7eb',
    fontSize: '14px',
    lineHeight: '1.5',
    transform: isHovered ? 'translateY(0)' : 'translateY(20px)',
    transition: 'transform 350ms ease 100ms',
  };

  return (
    <div
      className={className}
      style={containerStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <img
        src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4"
        alt="Mountain landscape"
        style={imageStyles}
      />
      <div style={overlayStyles}>
        <h3 style={titleStyles}>Beautiful Landscape</h3>
        <p style={descriptionStyles}>Discover amazing views and breathtaking scenery from around the world.</p>
      </div>
    </div>
  );
};
