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
  const primary = theme.primary || '#f59e0b';
  
  const sizes = {
    small: '20px',
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
          border: `2px solid #e5e7eb`,
          borderTopColor: primary,
          borderRadius: '50%',
          animation: `spin 1.2s linear infinite`
        }}
      />
      {label && (
        <span style={{ color: primary, fontSize: '17px', fontWeight: '300' }}>
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