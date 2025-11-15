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
  const primary = theme.primary || '#10b981';
  const percentage = (value / max) * 100;
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '450px' }}>
      {(label || showPercentage) && (
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', fontSize: '14px', color: '#374151' }}>
          {label && <span style={{ fontWeight: '600' }}> {label}</span>}
          {showPercentage && <span>{Math.round(percentage)}%</span>}
        </div>
      )}
      <div
        style={{
          width: '100%',
          height: '12px',
          backgroundColor: '#d1d5db',
          borderRadius: '8px',
          overflow: 'hidden',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}
      >
        <div
          style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: primary,
            borderRadius: '8px',
            transition: 'width 0.5s ease',
            background: 'linear-gradient(90deg, #10b981, #34d399)'
          }}
        />
      </div>
    </div>
  );
};