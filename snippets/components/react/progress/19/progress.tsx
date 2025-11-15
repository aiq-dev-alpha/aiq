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
  const primary = theme.primary || '#ef4444';
  const percentage = (value / max) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '420px' }}>
      {(label || showPercentage) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '14px', color: '#374151' }}>
          {label && <span style={{ fontWeight: '600' }}> {label}</span>}
          {showPercentage && <span>{Math.round(percentage)}%</span>}
        </div>
      )}
      <div
        style={{
          width: '100%',
          height: '16px',
          backgroundColor: '#d1d5db',
          borderRadius: '12px',
          overflow: 'hidden',
          boxShadow: '0 2px 6px rgba(0,0,0,0.08)'
        }}
      >
        <div
          style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '12px',
            transition: 'width 0.4s ease',
            background: 'linear-gradient(90deg, #ef4444, #f87171)'
          }}
        />
      </div>
    </div>
  );
};