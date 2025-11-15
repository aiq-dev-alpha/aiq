import React, { useState } from 'react';

export interface ComponentProps {
  label?: string;
  checked?: boolean;
  onChange?: (checked: boolean) => void;
  theme?: { primary?: string };
  className?: string;
  disabled?: boolean;
}

export const Component: React.FC<ComponentProps> = ({
  label = 'Checkbox',
  checked: controlledChecked,
  onChange,
  theme = {},
  className = '',
  disabled = false
}) => {
  const [internalChecked, setInternalChecked] = useState(false);
  const isChecked = controlledChecked !== undefined ? controlledChecked : internalChecked;
  const primary = theme.primary || '#ef4444';
  
  const handleChange = () => {
    if (disabled) return;
    const newChecked = !isChecked;
    if (controlledChecked === undefined) {
      setInternalChecked(newChecked);
    }
    onChange?.(newChecked);
  };
  
  return (
    <label
      className={className}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '2px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        opacity: disabled ? 0.5 : 1
      }}
    >
      <div
        onClick={handleChange}
        style={{
          width: '24px',
          height: '24px',
          borderRadius: '21px',
          border: `2px solid ${isChecked ? primary : '#d1d5db'}`,
          backgroundColor: isChecked ? primary : '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          transition: 'all 0.2s ease',
          boxShadow: isChecked ? '0 0 0 3px rgba(239,68,68,0.2)' : 'none'
        }}
      >
        {isChecked && (
          <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
            <path d="M6 10L9 13L14 7" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
      </div>
      <span style={{ fontSize: '13px', color: '#374151', userSelect: 'none' }}>
        {label}
      </span>
    </label>
  );
};