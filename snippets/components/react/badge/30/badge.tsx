import React from 'react';

export interface ComponentProps {
  variant?: 'default' | 'success' | 'warning' | 'error';
  position?: 'top-right' | 'top-left' | 'bottom-right' | 'bottom-left';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  children?: React.ReactNode;
}

export const Component: React.FC<ComponentProps> = ({
  variant = 'default',
  position = 'top-right',
  theme = {},
  className = '',
  children
}) => {
  const colors = {
    default: theme.primary || '#3b82f6',
    success: '#10b981',
    warning: '#f59e0b',
    error: '#ef4444'
  };

  const positions = {
    'top-right': { top: '0', right: '0' },
    'top-left': { top: '0', left: '0' },
    'bottom-right': { bottom: '0', right: '0' },
    'bottom-left': { bottom: '0', left: '0' }
  };

  return (
    <div className={className} style={{ position: 'relative', display: 'inline-block' }}>
      {children || (
        <div
          style={{
            width: '48px',
            height: '48px',
            borderRadius: '50%',
            backgroundColor: '#f3f4f6'
          }}
        />
      )}
      <div
        style={{
          position: 'absolute',
          ...positions[position],
          width: '12px',
          height: '12px',
          borderRadius: '50%',
          backgroundColor: colors[variant],
          border: '2px solid #fff'
        }}
      />
    </div>
  );
};