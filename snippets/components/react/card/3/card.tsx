import React from 'react';
import './card.css';

// Version 3: Minimal flat card with accent

interface CardProps {
  title?: string;
  subtitle?: string;
  badge?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  className?: string;
  accentPosition?: 'top' | 'left' | 'none';
  onClick?: () => void;
}

export const Card: React.FC<CardProps> = ({
  title,
  subtitle,
  badge,
  children,
  footer,
  className = '',
  accentPosition = 'top',
  onClick
}) => {
  return (
    <div 
      className={`card_v3 card_v3_accent_${accentPosition} ${className} ${onClick ? 'card_v3_clickable' : ''}`}
      onClick={onClick}
    >
      {(title || subtitle || badge) && (
        <div className="card_v3_header">
          <div className="card_v3_header_main">
            {title && <h3 className="card_v3_title">{title}</h3>}
            {subtitle && <p className="card_v3_subtitle">{subtitle}</p>}
          </div>
          {badge && <span className="card_v3_badge">{badge}</span>}
        </div>
      )}
      
      <div className="card_v3_content">
        {children}
      </div>
      
      {footer && (
        <div className="card_v3_footer">
          {footer}
        </div>
      )}
    </div>
  );
};

export default Card;
