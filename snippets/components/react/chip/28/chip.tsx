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
  const primary = theme.primary || '#78350f';
  
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
        padding: '18px 29px',
        borderRadius: '24px',
        fontSize: '17px',
        fontWeight: '300',
        lineHeight: '1.5'
      }}
    >
      {icon && <span style={{ fontSize: '17px' }}> {icon}</span>}
      <span>{label}</span>
      {onDelete && (
        <button
          onClick={onDelete}
          style={{
            background: 'none',
            border: 'none',
            color: 'inherit',
            cursor: 'pointer',
            fontSize: '17px',
            padding: '0',
            lineHeight: '1.5',
            marginLeft: '4px'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};