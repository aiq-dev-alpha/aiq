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

  const [selectedTier, setSelectedTier] = useState(false);

  const containerStyles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transform: isVisible ? (isHovered ? 'translateY(-8px)' : 'translateY(0)') : 'translateY(20px)',
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
    padding: '32px',
    backgroundColor: selectedTier ? (theme.primary || '#3b82f6') : (theme.background || '#ffffff'),
    color: selectedTier ? '#ffffff' : (theme.text || '#111827'),
    borderRadius: '16px',
    border: selectedTier ? 'none' : `2px solid ${isHovered ? (theme.primary || '#3b82f6') : '#e5e7eb'}`,
    boxShadow: isHovered ? '0 20px 40px rgba(59,130,246,0.3)' : '0 4px 12px rgba(0,0,0,0.1)',
    cursor: 'pointer',
    width: '280px',
    position: 'relative',
  };

  const badgeStyles: React.CSSProperties = {
    position: 'absolute',
    top: '-12px',
    right: '24px',
    backgroundColor: '#10b981',
    color: '#ffffff',
    padding: '4px 12px',
    borderRadius: '12px',
    fontSize: '12px',
    fontWeight: '600',
    textTransform: 'uppercase',
  };

  const tierStyles: React.CSSProperties = {
    fontSize: '14px',
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: '1px',
    marginBottom: '8px',
    opacity: 0.8,
  };

  const priceStyles: React.CSSProperties = {
    fontSize: '48px',
    fontWeight: 'bold',
    marginBottom: '8px',
  };

  const periodStyles: React.CSSProperties = {
    fontSize: '16px',
    opacity: 0.7,
    marginBottom: '24px',
  };

  const featureListStyles: React.CSSProperties = {
    listStyle: 'none',
    padding: 0,
    margin: '24px 0',
  };

  const featureItemStyles: React.CSSProperties = {
    padding: '12px 0',
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    borderBottom: `1px solid ${selectedTier ? 'rgba(255,255,255,0.2)' : '#e5e7eb'}`,
  };

  const buttonStyles: React.CSSProperties = {
    width: '100%',
    padding: '14px',
    borderRadius: '8px',
    border: 'none',
    backgroundColor: selectedTier ? '#ffffff' : (theme.primary || '#3b82f6'),
    color: selectedTier ? (theme.primary || '#3b82f6') : '#ffffff',
    fontSize: '16px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 200ms ease',
    marginTop: '16px',
  };

  const features = [
    'Unlimited projects',
    'Advanced analytics',
    '24/7 Priority support',
    'Custom integrations',
  ];

  return (
    <div
      className={className}
      style={containerStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      onClick={() => setSelectedTier(!selectedTier)}
    >
      {selectedTier && <div style={badgeStyles}>Popular</div>}
      <div style={tierStyles}>Professional</div>
      <div style={priceStyles}>$49</div>
      <div style={periodStyles}>per month</div>
      <ul style={featureListStyles}>
        {features.map((feature, index) => (
          <li key={index} style={featureItemStyles}>
            <span>✓</span>
            <span>{feature}</span>
          </li>
        ))}
      </ul>
      <button style={buttonStyles}>Get Started</button>
    </div>
  );
};
