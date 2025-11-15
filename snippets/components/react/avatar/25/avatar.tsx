import React from 'react';

export interface ComponentProps {
  src?: string;
  alt?: string;
  name?: string;
  size?: 'small' | 'medium' | 'large';
  theme?: { primary?: string };
  className?: string;
  shape?: 'circle' | 'square';
}

export const Component: React.FC<ComponentProps> = ({
  src,
  alt = 'Avatar',
  name = 'JD',
  size = 'medium',
  theme = {},
  className = '',
  shape = 'square'
}) => {
  const primary = theme.primary || '#14b8a6';
  const sizes = {
    small: { width: '32px', height: '32px', fontSize: '22px' },
    medium: { width: '48px', height: '48px', fontSize: '22px' },
    large: { width: '64px', height: '64px', fontSize: '22px' }
  };

  const sizeStyle = sizes[size];
  const borderRadius = shape === 'circle' ? '50%' : '12px';

  return (
    <div
      className={className}
      style={{
        width: sizeStyle.width,
        height: sizeStyle.height,
        borderRadius,
        backgroundColor: src ? 'transparent' : primary,
        color: '#fff',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontWeight: '700',
        fontSize: sizeStyle.fontSize,
        overflow: 'hidden',
        border: '2px solid ${primary}',
        boxShadow: '0 18px 32px rgba(0,0,0,0.28)'
      }}
    >
      {src ? (
        <img src={src} alt={alt} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
      ) : (
        <span>{name}</span>
      )}
    </div>
  );
};