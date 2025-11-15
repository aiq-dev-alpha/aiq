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
  const [quantity, setQuantity] = useState(1);
  const [isInCart, setIsInCart] = useState(false);

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
    transform: isVisible ? 'translateY(0)' : 'translateY(20px)',
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
    backgroundColor: theme.background || '#ffffff',
    borderRadius: '16px',
    overflow: 'hidden',
    boxShadow: isHovered ? '0 16px 32px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.06)',
    cursor: 'pointer',
    width: '280px',
  };

  const imageContainerStyles: React.CSSProperties = {
    position: 'relative',
    width: '100%',
    height: '280px',
    overflow: 'hidden',
    backgroundColor: '#f9fafb',
  };

  const imageStyles: React.CSSProperties = {
    width: '100%',
    height: '100%',
    objectFit: 'cover' as const,
    transition: 'transform 400ms ease',
    transform: isHovered ? 'scale(1.1)' : 'scale(1)',
  };

  const badgeStyles: React.CSSProperties = {
    position: 'absolute',
    top: '12px',
    right: '12px',
    backgroundColor: '#ef4444',
    color: '#ffffff',
    padding: '6px 12px',
    borderRadius: '6px',
    fontSize: '12px',
    fontWeight: '700',
  };

  const contentStyles: React.CSSProperties = {
    padding: '20px',
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '18px',
    fontWeight: '700',
    color: theme.text || '#111827',
    marginBottom: '8px',
  };

  const descriptionStyles: React.CSSProperties = {
    fontSize: '13px',
    color: '#6b7280',
    marginBottom: '16px',
    lineHeight: '1.5',
  };

  const ratingStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    marginBottom: '16px',
    fontSize: '14px',
  };

  const priceContainerStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    marginBottom: '16px',
  };

  const priceStyles: React.CSSProperties = {
    fontSize: '28px',
    fontWeight: 'bold',
    color: theme.primary || '#3b82f6',
  };

  const oldPriceStyles: React.CSSProperties = {
    fontSize: '18px',
    color: '#9ca3af',
    textDecoration: 'line-through',
  };

  const quantitySelectorStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    marginBottom: '16px',
  };

  const quantityButtonStyles: React.CSSProperties = {
    width: '32px',
    height: '32px',
    borderRadius: '6px',
    border: '1px solid #e5e7eb',
    backgroundColor: '#ffffff',
    cursor: 'pointer',
    fontSize: '18px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  };

  const addToCartButtonStyles: React.CSSProperties = {
    width: '100%',
    padding: '14px',
    borderRadius: '10px',
    border: 'none',
    backgroundColor: isInCart ? '#10b981' : (theme.primary || '#3b82f6'),
    color: '#ffffff',
    fontSize: '15px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 200ms ease',
    transform: isHovered ? 'scale(1.02)' : 'scale(1)',
  };

  return (
    <div
      className={className}
      style={containerStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <div style={imageContainerStyles}>
        <img
          src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e"
          alt="Wireless Headphones"
          style={imageStyles}
        />
        <div style={badgeStyles}>-25%</div>
      </div>
      <div style={contentStyles}>
        <h3 style={titleStyles}>Premium Wireless Headphones</h3>
        <p style={descriptionStyles}>
          High-quality sound with active noise cancellation
        </p>
        <div style={ratingStyles}>
          <span>⭐⭐⭐⭐⭐</span>
          <span style={{ color: '#6b7280' }}>(128 reviews)</span>
        </div>
        <div style={priceContainerStyles}>
          <span style={priceStyles}>$149</span>
          <span style={oldPriceStyles}>$199</span>
        </div>
        <div style={quantitySelectorStyles}>
          <button
            style={quantityButtonStyles}
            onClick={(e) => {
              e.stopPropagation();
              setQuantity(Math.max(1, quantity - 1));
            }}
          >
            -
          </button>
          <span style={{ fontSize: '16px', fontWeight: '600', minWidth: '30px', textAlign: 'center' as const }}>
            {quantity}
          </span>
          <button
            style={quantityButtonStyles}
            onClick={(e) => {
              e.stopPropagation();
              setQuantity(quantity + 1);
            }}
          >
            +
          </button>
        </div>
        <button
          style={addToCartButtonStyles}
          onClick={(e) => {
            e.stopPropagation();
            setIsInCart(!isInCart);
          }}
        >
          {isInCart ? '✓ Added to Cart' : '🛒 Add to Cart'}
        </button>
      </div>
    </div>
  );
};
