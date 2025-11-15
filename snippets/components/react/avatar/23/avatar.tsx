import React from 'react';;

export interface ComponentProps {
  name?: string;
  src?: string;
  size?: number;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  name = 'User',
  src = '',
  size = 80,
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#8b5cf6';

  return (
  <div className={className}>
  <div
  style={{
  width: `${size}px`,
  height: `${size}px`,
  clipPath: 'polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%)',
  backgroundColor: primary,
  color: '#fff',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: `${size * 0.35}px`,
  fontWeight: '700',
  position: 'relative',
  transition: 'transform 0.3s ease'
  }}
  onMouseEnter={(e) => e.currentTarget.style.transform = 'scale(1.1) rotate(15deg)'}
  onMouseLeave={(e) => e.currentTarget.style.transform = 'scale(1) rotate(0deg)'}
  >
  {name.charAt(0).toUpperCase()}
  </div>
  </div>
  );
};