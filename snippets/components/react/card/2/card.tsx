import React from 'react';
import './card.css';

// Version 2: Modern gradient border card

interface CardProps {
  title?: string;
  subtitle?: string;
  icon?: React.ReactNode;
  children: React.ReactNode;
  footer?: React.ReactNode;
  className?: string;
  variant?: 'blue' | 'purple' | 'green' | 'orange';
  onClick?: () => void;
}

export const Card: React.FC<CardProps> = ({
  title,
  subtitle,
  icon,
  children,
  footer,
  className = '',
  variant = 'blue',
  onClick
}) => {
  return (
    <div 
      className={`card_v2 card_v2_${variant} ${className} ${onClick ? 'card_v2_clickable' : ''}`}
      onClick={onClick}
    >
      <div className="card_v2_gradient_border"></div>
      
      <div className="card_v2_inner">
        {(title || subtitle || icon) && (
          <div className="card_v2_header">
            {icon && <div className="card_v2_icon">{icon}</div>}
            <div className="card_v2_header_text">
              {title && <h3 className="card_v2_title">{title}</h3>}
              {subtitle && <p className="card_v2_subtitle">{subtitle}</p>}
            </div>
          </div>
        )}
        
        <div className="card_v2_content">
          {children}
        </div>
        
        {footer && (
          <div className="card_v2_footer">
            {footer}
          </div>
        )}
      </div>
    </div>
  );
};

export default Card;
