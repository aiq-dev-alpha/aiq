import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  count?: number;
  onRemove?: () => void;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Filter',
  count = 0,
  onRemove,
  theme = {},
  className = ''
}) => {
  const [isActive, setIsActive] = useState(true);
  const primary = theme.primary || '#3b82f6';

  if (!isActive) return null;

  return (
    <div
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '8px',
        padding: '6px 12px',
        backgroundColor: `${primary}15`,
        border: `1px solid ${primary}`,
        borderRadius: '20px',
        fontSize: '14px',
        color: primary,
        fontWeight: '500'
      }}
    >
      <span>{label}</span>
      {count > 0 && (
        <span
          style={{
            backgroundColor: primary,
            color: '#fff',
            borderRadius: '10px',
            padding: '2px 6px',
            fontSize: '12px',
            fontWeight: '600'
          }}
        >
          {count}
        </span>
      )}
      <button
        onClick={() => {
          setIsActive(false);
          onRemove?.();
        }}
        style={{
          background: 'none',
          border: 'none',
          color: primary,
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
    </div>
  );
};