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
    transform: isVisible ? 'translateX(0)' : 'translateX(-30px)',
    transition: 'all 350ms cubic-bezier(0.4, 0, 0.2, 1)',
    display: 'flex',
    flexDirection: 'row' as const,
    backgroundColor: theme.background || '#ffffff',
    borderRadius: '16px',
    overflow: 'hidden',
    boxShadow: isHovered ? '0 12px 28px rgba(0,0,0,0.15)' : '0 4px 12px rgba(0,0,0,0.08)',
    cursor: 'pointer',
    maxWidth: '600px',
    height: '220px',
  };

  const imageContainerStyles: React.CSSProperties = {
    flex: '0 0 240px',
    position: 'relative' as const,
    overflow: 'hidden',
  };

  const imageStyles: React.CSSProperties = {
    width: '100%',
    height: '100%',
    objectFit: 'cover' as const,
    transition: 'transform 500ms ease',
    transform: isHovered ? 'scale(1.15)' : 'scale(1)',
  };

  const contentStyles: React.CSSProperties = {
    flex: 1,
    padding: '24px',
    display: 'flex',
    flexDirection: 'column' as const,
    justifyContent: 'space-between',
  };

  const categoryStyles: React.CSSProperties = {
    fontSize: '12px',
    color: theme.primary || '#3b82f6',
    textTransform: 'uppercase' as const,
    fontWeight: '600',
    letterSpacing: '1px',
    marginBottom: '8px',
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '22px',
    fontWeight: 'bold',
    color: theme.text || '#111827',
    marginBottom: '12px',
    lineHeight: '1.3',
  };

  const descriptionStyles: React.CSSProperties = {
    fontSize: '14px',
    color: '#6b7280',
    lineHeight: '1.6',
    marginBottom: '16px',
  };

  const footerStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
  };

  const metaStyles: React.CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '16px',
    fontSize: '13px',
    color: '#9ca3af',
  };

  const buttonStyles: React.CSSProperties = {
    padding: '10px 20px',
    borderRadius: '8px',
    border: 'none',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    fontSize: '14px',
    fontWeight: '600',
    cursor: 'pointer',
    transition: 'all 200ms ease',
    transform: isHovered ? 'translateX(4px)' : 'translateX(0)',
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
          src="https://images.unsplash.com/photo-1498050108023-c5249f4df085"
          alt="Workspace"
          style={imageStyles}
        />
      </div>
      <div style={contentStyles}>
        <div>
          <div style={categoryStyles}>Technology</div>
          <h3 style={titleStyles}>Modern Workspace Design Trends</h3>
          <p style={descriptionStyles}>
            Explore the latest trends in workspace design and how they can boost productivity.
          </p>
        </div>
        <div style={footerStyles}>
          <div style={metaStyles}>
            <span>📅 Dec 15, 2024</span>
            <span>⏱️ 5 min read</span>
          </div>
          <button style={buttonStyles}>Read More →</button>
        </div>
      </div>
    </div>
  );
};
