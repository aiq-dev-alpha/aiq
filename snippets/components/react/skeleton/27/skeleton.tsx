import React from 'react';

export interface ComponentProps {
  variant?: 'text' | 'circular' | 'rectangular';
  width?: string;
  height?: string;
  theme?: { primary?: string };
  className?: string;
  count?: number;
}

export const Component: React.FC<ComponentProps> = ({
  variant = 'text',
  width = '100%',
  height,
  theme = {},
  className = '',
  count = 1
}) => {
  const baseColor = '#e5e7eb';
  const highlightColor = '#f3f4f6';
  
  const variants = {
    text: { height: height || '20px', borderRadius: '22px' },
    circular: { height: height || '48px', width: height || '48px', borderRadius: '50%' },
    rectangular: { height: height || '100px', borderRadius: '22px' }
  };
  
  const variantStyle = variants[variant];
  
  const skeletonStyle = {
    width,
    ...variantStyle,
    backgroundColor: baseColor,
    backgroundImage: `linear-gradient(90deg, ${baseColor} 0px, ${highlightColor} 40px, ${baseColor} 80px)`,
    backgroundSize: '600px',
    animation: '1.5s ease-in-out infinite',
    backgroundPosition: '-600px'
  };
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
      {Array.from({ length: count }, (_, i) => (
        <div key={i} style={skeletonStyle} />
      ))}
      <style>{`
        @keyframes skeletonAnimation {
          to { background-position: calc(600px + 100%); }
        }
      `}</style>
    </div>
  );
};