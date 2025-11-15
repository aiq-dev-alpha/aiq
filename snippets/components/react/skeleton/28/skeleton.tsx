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
  const baseColor = '#d1d5db';
  const highlightColor = '#e5e7eb';
  
  const variants = {
    text: { height: height || '16px', borderRadius: '24px' },
    circular: { height: height || '56px', width: height || '56px', borderRadius: '50%' },
    rectangular: { height: height || '120px', borderRadius: '24px' }
  };
  
  const variantStyle = variants[variant];
  
  const skeletonStyle = {
    width,
    ...variantStyle,
    backgroundColor: baseColor,
    backgroundImage: `linear-gradient(90deg, ${baseColor} 0px, ${highlightColor} 40px, ${baseColor} 80px)`,
    backgroundSize: '800px',
    animation: '1.2s ease-in-out infinite',
    backgroundPosition: '-800px'
  };
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
      {Array.from({ length: count }, (_, i) => (
        <div key={i} style={skeletonStyle} />
      ))}
      <style>{`
        @keyframes skeletonAnimation {
          to { background-position: calc(800px + 100%); }
        }
      `}</style>
    </div>
  );
};