import React from 'react';

export interface ComponentProps {
  name?: string;
  label?: string;
  onRemove?: () => void;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  name = 'User',
  label,
  onRemove,
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#06b6d4';

  return (
    <div
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        padding: '4px 12px 4px 4px',
        backgroundColor: '#f3f4f6',
        borderRadius: '24px',
        fontSize: '14px',
        color: '#374151'
      }}
    >
      <div
        style={{
          width: '28px',
          height: '28px',
          borderRadius: '50%',
          backgroundColor: primary,
          color: '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '12px',
          fontWeight: '600'
        }}
      >
        {name.charAt(0).toUpperCase()}
      </div>
      <span style={{ fontWeight: '500' }}>{label || name}</span>
      {onRemove && (
        <button
          onClick={onRemove}
          style={{
            background: 'none',
            border: 'none',
            color: '#6b7280',
            cursor: 'pointer',
            padding: '0',
            display: 'flex',
            alignItems: 'center',
            fontSize: '18px',
            lineHeight: '1'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};