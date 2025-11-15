import React from 'react';

export interface ComponentProps {
  value?: number;
  max?: number;
  theme?: { primary?: string };
  className?: string;
  label?: string;
  showPercentage?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  value = 50,
  max = 100,
  theme = {},
  className = '',
  label,
  showPercentage = true
}) => {
  const primary = theme.primary || '#3b82f6';
  const percentage = (value / max) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '400px' }}>
      {(label || showPercentage) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '14px', color: '#374151' }}>
          {label && <span style={{ fontWeight: '500' }}> {label}</span>}
          {showPercentage && <span>{Math.round(percentage)}%</span>}
        </div>
      )}
      <div
        style={{
          width: '100%',
          height: '8px',
          backgroundColor: '#e5e7eb',
          borderRadius: '6px',
          overflow: 'hidden',
          boxShadow: 'none'
        }}
      >
        <div
          style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '6px',
            transition: 'width 0.3s ease',
            background: 'none'
          }}
        />
      </div>
    </div>
  );
};