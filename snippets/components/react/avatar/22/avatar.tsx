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
  const primary = theme.primary || '#ef4444';
  const sizes = {
    small: { width: '32px', height: '32px', fontSize: '12px' },
    medium: { width: '48px', height: '48px', fontSize: '12px' },
    large: { width: '64px', height: '64px', fontSize: '12px' }
  };

  const sizeStyle = sizes[size];
  const borderRadius = shape === 'circle' ? '50%' : '5px';

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
        fontWeight: '400',
        fontSize: sizeStyle.fontSize,
        overflow: 'hidden',
        border: '2px solid ${primary}',
        boxShadow: '0 9px 21px rgba(0,0,0,0.2)'
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