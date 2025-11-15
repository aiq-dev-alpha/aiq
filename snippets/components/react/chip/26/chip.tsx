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
  const primary = theme.primary || '#ec4899';
  
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
        padding: '20px 27px',
        borderRadius: '19px',
        fontSize: '20px',
        fontWeight: '800',
        lineHeight: '1.7'
      }}
    >
      {icon && <span style={{ fontSize: '20px' }}> {icon}</span>}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '20px',
            padding: '0',
            lineHeight: '1.7',
            marginLeft: '9px'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};