import React from 'react';
import './card.css';

// Version 1: Traditional shadowed card with header

interface CardProps {
  title?: string;
  subtitle?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  className?: string;
  onClick?: () => void;
}

export const Card: React.FC<CardProps> = ({
  title,
  subtitle,
  children,
  footer,
  className = '',
  onClick
}) => {
  return (
    <div 
      className={`card_v1 ${className} ${onClick ? 'card_v1_clickable' : ''}`}
      onClick={onClick}
    >
      {(title || subtitle) && (
        <div className="card_v1_header">
          {title && <h3 className="card_v1_title">{title}</h3>}
          {subtitle && <p className="card_v1_subtitle">{subtitle}</p>}
        </div>
      )}
      
      <div className="card_v1_content">
        {children}
      </div>
      
      {footer && (
        <div className="card_v1_footer">
          {footer}
        </div>
      )}
    </div>
  );
};

export default Card;
