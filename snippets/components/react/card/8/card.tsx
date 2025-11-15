import React, { useState } from 'react';

export interface ComponentProps {
  title?: string;
  description?: string;
  imageUrl?: string;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onInteract?: () => void;
}

export const Component: React.FC<ComponentProps> = ({
  title = 'Card Title',
  description = 'Card description goes here',
  imageUrl,
  theme = {},
  className = '',
  onInteract
}) => {
  const [isHovered, setIsHovered] = useState(false);

  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  return (
  <div
  className={className}
  onClick={onInteract}
  onMouseEnter={() => setIsHovered(true)}
  onMouseLeave={() => setIsHovered(false)}
  style={{
  backgroundColor: background,
  borderRadius: '16px',
  overflow: 'hidden',
  boxShadow: isHovered 
  ? '0 20px 40px rgba(0,0,0,0.15)'
  : '0 4px 12px rgba(0,0,0,0.08)',
  transform: isHovered ? 'translateY(-8px)' : 'translateY(0)',
  transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
  cursor: onInteract ? 'pointer' : 'default',
  maxWidth: '400px'
  }}
  >
  {imageUrl && (
  <div style={{
  width: '100%',
  height: '200px',
  backgroundImage: `url(${imageUrl})`,
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  transform: isHovered ? 'scale(1.05)' : 'scale(1)',
  transition: 'transform 300ms'
  }} />
  )}
  <div style={{ padding: '24px' }}>
  <h3 style={{ 
  margin: '0 0 12px 0',
  color: text,
  fontSize: '24px',
  fontWeight: 700
  }}>
  {title}
  </h3>
  <p style={{ 
  margin: 0,
  color: `${text}99`,
  fontSize: '16px',
  lineHeight: '1.6'
  }}>
  {description}
  </p>
  {onInteract && (
  <button style={{
  marginTop: '16px',
  padding: '8px 20px',
  backgroundColor: primary,
  color: '#ffffff',
  border: 'none',
  borderRadius: '8px',
  fontSize: '14px',
  fontWeight: 600,
  cursor: 'pointer'
  }}>
  Learn More
  </button>
  )}
  </div>
  </div>
  );
};