import React from 'react';

export interface ComponentProps {
  size?: 'small' | 'medium' | 'large';
  theme?: { primary?: string };
  className?: string;
  label?: string;
}

export const Component: React.FC<ComponentProps> = ({
  size = 'medium',
  theme = {},
  className = '',
  label
}) => {
  const primary = theme.primary || '#ec4899';
  
  const sizes = {
    small: '25px',
    medium: '40px',
    large: '60px'
  };
  
  const spinnerSize = sizes[size];
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '19px' }}>
      <div
        style={{
          width: spinnerSize,
          height: spinnerSize,
          border: `9px solid #d1d5db`,
          borderTopColor: primary,
          borderRadius: '50%',
          animation: `spin 0.8s ease-in-out infinite`
        }}
      />
      {label && (
        <span style={{ color: primary, fontSize: '19px', fontWeight: '800' }}>
          {label}
        </span>
      )}
      <style>{`
        @keyframes spin {
          to { transform: rotate(360deg); }
        }
      `}</style>
    </div>
  );
};