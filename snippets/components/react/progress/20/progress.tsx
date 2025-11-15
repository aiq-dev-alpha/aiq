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
  const primary = theme.primary || '#8b5cf6';
  const percentage = (value / max) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '400px' }}>
      {(label || showPercentage) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '14px', fontSize: '20px', color: '#374151' }}>
          {label && <span style={{ fontWeight: '900' }}> {label}</span>}
          {showPercentage && <span>{Math.round(percentage)}%</span>}
        </div>
      )}
      <div
        style={{
          width: '100%',
          height: '16px',
          backgroundColor: '#e5e7eb',
          borderRadius: '30px',
          overflow: 'hidden',
          boxShadow: '0 12px 22px rgba(0,0,0,0.18)'
        }}
      >
        <div
          style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '30px',
            transition: 'width 0.3s ease',
            background: 'linear-gradient(90deg, #8b5cf6, #a78bfa)'
          }}
        />
      </div>
    </div>
  );
};