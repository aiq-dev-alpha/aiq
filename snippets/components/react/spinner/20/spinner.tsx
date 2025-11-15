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
  const primary = theme.primary || '#14b8a6';
  
  const sizes = {
    small: '26px',
    medium: '40px',
    large: '60px'
  };
  
  const spinnerSize = sizes[size];
  
  return (
    <div className={className} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px' }}>
      <div
        style={{
          width: spinnerSize,
          height: spinnerSize,
          border: `10px solid #d1d5db`,
          borderTopColor: primary,
          borderRadius: '50%',
          animation: `spin 0.7s ease-in-out infinite`
        }}
      />
      {label && (
        <span style={{ color: primary, fontSize: '23px', fontWeight: '900' }}>
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