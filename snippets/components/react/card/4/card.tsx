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
    transform: isVisible ? 'scale(1)' : 'scale(0.95)',
    transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
    padding: '32px',
    backgroundColor: theme.background || '#ffffff',
    borderRadius: '20px',
    boxShadow: isHovered ? '0 12px 32px rgba(0,0,0,0.15)' : '0 4px 16px rgba(0,0,0,0.08)',
    cursor: 'pointer',
    width: '320px',
    textAlign: 'center' as const,
  };

  const avatarContainerStyles: React.CSSProperties = {
    position: 'relative',
    display: 'inline-block',
    marginBottom: '20px',
  };

  const avatarStyles: React.CSSProperties = {
    width: '120px',
    height: '120px',
    borderRadius: '50%',
    objectFit: 'cover' as const,
    border: `4px solid ${theme.primary || '#3b82f6'}`,
    transition: 'transform 300ms ease',
    transform: isHovered ? 'scale(1.05)' : 'scale(1)',
  };

  const statusBadgeStyles: React.CSSProperties = {
    position: 'absolute',
    bottom: '8px',
    right: '8px',
    width: '20px',
    height: '20px',
    borderRadius: '50%',
    backgroundColor: '#10b981',
    border: '3px solid #ffffff',
  };

  const nameStyles: React.CSSProperties = {
    fontSize: '24px',
    fontWeight: 'bold',
    color: theme.text || '#111827',
    marginBottom: '4px',
  };

  const roleStyles: React.CSSProperties = {
    fontSize: '14px',
    color: theme.primary || '#3b82f6',
    marginBottom: '16px',
    fontWeight: '500',
  };

  const bioStyles: React.CSSProperties = {
    fontSize: '14px',
    color: '#6b7280',
    lineHeight: '1.6',
    marginBottom: '24px',
  };

  const socialLinksStyles: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'center',
    gap: '16px',
    marginBottom: '24px',
  };

  const socialIconStyles: React.CSSProperties = {
    width: '40px',
    height: '40px',
    borderRadius: '50%',
    backgroundColor: '#f3f4f6',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    cursor: 'pointer',
    transition: 'all 200ms ease',
    fontSize: '18px',
  };

  const buttonStyles: React.CSSProperties = {
    width: '100%',
    padding: '12px',
    borderRadius: '10px',
    border: `2px solid ${theme.primary || '#3b82f6'}`,
    backgroundColor: 'transparent',
    color: theme.primary || '#3b82f6',
    fontSize: '14px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 200ms ease',
  };

  return (
    <div
      className={className}
      style={containerStyles}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <div style={avatarContainerStyles}>
        <img
          src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e"
          alt="Profile"
          style={avatarStyles}
        />
        <div style={statusBadgeStyles} />
      </div>
      <div style={nameStyles}>Alex Johnson</div>
      <div style={roleStyles}>Senior Product Designer</div>
      <p style={bioStyles}>
        Passionate about creating beautiful and functional user experiences.
        Based in San Francisco.
      </p>
      <div style={socialLinksStyles}>
        <div style={socialIconStyles}>𝕏</div>
        <div style={socialIconStyles}>in</div>
        <div style={socialIconStyles}>📷</div>
        <div style={socialIconStyles}>🌐</div>
      </div>
      <button style={buttonStyles}>Connect</button>
    </div>
  );
};
