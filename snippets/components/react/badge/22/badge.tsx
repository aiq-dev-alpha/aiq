import React from 'react';

export interface ComponentProps {
  count?: number;
  max?: number;
  showZero?: boolean;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  children?: React.ReactNode;
}

export const Component: React.FC<ComponentProps> = ({
  count = 0,
  max = 99,
  showZero = false,
  theme = {},
  className = '',
  children
}) => {
  const primary = theme.primary || '#ef4444';
  const displayCount = count > max ? `${max}+` : count;
  const shouldShow = count > 0 || showZero;

  return (
    <div className={className} style={{ position: 'relative', display: 'inline-block' }}>
      {children || (
        <div
          style={{
            width: '48px',
            height: '48px',
            borderRadius: '8px',
            backgroundColor: '#f3f4f6',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center'
          }}
        >
          🔔
        </div>
      )}
      {shouldShow && (
        <div
          style={{
            position: 'absolute',
            top: '-8px',
            right: '-8px',
            minWidth: '24px',
            height: '24px',
            borderRadius: '12px',
            backgroundColor: primary,
            color: '#fff',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '12px',
            fontWeight: '700',
            padding: '0 6px',
            boxShadow: '0 2px 8px rgba(0,0,0,0.2)'
          }}
        >
          {displayCount}
        </div>
      )}
    </div>
  );
};