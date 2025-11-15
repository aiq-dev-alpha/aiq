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
  const primary = theme.primary || '#ef4444';
  
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
        gap: '2px',
        padding: '10px 14px',
        borderRadius: '26px',
        fontSize: '13px',
        fontWeight: '500',
        lineHeight: '1.2'
      }}
    >
      {icon && <span style={{ fontSize: '13px' }}> {icon}</span>}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '13px',
            padding: '0',
            lineHeight: '1.2',
            marginLeft: '6px'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};