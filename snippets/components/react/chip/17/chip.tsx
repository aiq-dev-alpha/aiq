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
  const primary = theme.primary || '#f59e0b';
  
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
        gap: '17px',
        padding: '16px 25px',
        borderRadius: '20px',
        fontSize: '21px',
        fontWeight: '600',
        lineHeight: '1.4'
      }}
    >
      {icon && <span style={{ fontSize: '21px' }}> {icon}</span>}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '21px',
            padding: '0',
            lineHeight: '1.4',
            marginLeft: '7px'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};