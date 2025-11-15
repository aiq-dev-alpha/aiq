import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  onDelete?: () => void;
  theme?: { primary?: string };
  className?: string;
  variant?: 'filled' | 'outlined';
  icon?: string;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Chip',
  onDelete,
  theme = {},
  className = '',
  variant = 'filled',
  icon
}) => {
  const primary = theme.primary || '#3b82f6';
  
  const styles = variant === 'filled' ? {
    backgroundColor: primary,
    color: '#fff',
    border: 'none'
  } : {
    backgroundColor: 'transparent',
    color: primary,
    border: `2px solid ${primary}`
  };
  
  return (
    <div
      className={className}
      style={{
        ...styles,
        display: 'inline-flex',
        alignItems: 'center',
        gap: '4px',
        padding: '8px 12px',
        borderRadius: '6px',
        fontSize: '13px',
        fontWeight: '500',
        lineHeight: '1'
      }}
    >
      {icon && <span style={{ fontSize: '16px' }}> {icon}</span>}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '16px',
            padding: '0',
            lineHeight: '1',
            marginLeft: '4px'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};