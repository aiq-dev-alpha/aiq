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
  const highlightColor = '#f3f4f6';
  
  const variants = {
    text: { height: height || '23px', borderRadius: '19px' },
    circular: { height: height || '64px', width: height || '64px', borderRadius: '50%' },
    rectangular: { height: height || '140px', borderRadius: '19px' }
  };
  
  const variantStyle = variants[variant];
  
  const skeletonStyle = {
    width,
    ...variantStyle,
    backgroundColor: baseColor,
    backgroundImage: `linear-gradient(90deg, ${baseColor} 0px, ${highlightColor} 40px, ${baseColor} 80px)`,
    backgroundSize: '1000px',
    animation: '1s ease-in-out infinite',
    backgroundPosition: '-1000px'
  };
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
      {Array.from({ length: count }, (_, i) => (
        <div key={i} style={skeletonStyle} />
      ))}
      <style>{`
        @keyframes skeletonAnimation {
          to { background-position: calc(1000px + 100%); }
        }
      `}</style>
    </div>
  );
};