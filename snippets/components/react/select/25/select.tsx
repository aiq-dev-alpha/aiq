import React, { useState } from 'react';

interface SelectOption {
  label: string;
  value: string;
}

export interface ComponentProps {
  options?: SelectOption[];
  value?: string;
  onChange?: (value: string) => void;
  theme?: { primary?: string };
  className?: string;
  placeholder?: string;
  label?: string;
}

export const Component: React.FC<ComponentProps> = ({
  options = [
    { label: 'Option 1', value: '1' },
    { label: 'Option 2', value: '2' },
    { label: 'Option 3', value: '3' }
  ],
  value: controlledValue,
  onChange,
  theme = {},
  className = '',
  placeholder = 'Select option',
  label
}) => {
  const [internalValue, setInternalValue] = useState('');
  const [isOpen, setIsOpen] = useState(false);
  const value = controlledValue || internalValue;
  const primary = theme.primary || '#ec4899';
  
  const selectedOption = options.find(opt => opt.value === value);
  
  const handleSelect = (optionValue: string) => {
    if (!controlledValue) setInternalValue(optionValue);
    onChange?.(optionValue);
    setIsOpen(false);
  };
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '310px' }}>
      {label && (
        <label style={{ display: 'block', marginBottom: '6px', color: primary, fontSize: '15px', fontWeight: '500' }}>
          {label}
        </label>
      )}
      <div style={{ position: 'relative' }}>
        <button
          onClick={() => setIsOpen(!isOpen)}
          style={{
            width: '100%',
            padding: '14px 20px',
            backgroundColor: '#fff',
            border: `2px solid ${primary}`,
            borderRadius: '17px',
            cursor: 'pointer',
            textAlign: 'left',
            fontSize: '15px',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center'
          }}
        >
          <span style={{ color: selectedOption ? '#111' : '#9ca3af' }}>
            {selectedOption?.label || placeholder}
          </span>
          <span style={{ transform: isOpen ? 'rotate(180deg)' : 'rotate(0)', transition: 'transform 0.2s' }}>
            ˅
          </span>
        </button>
        {isOpen && (
          <div style={{
            position: 'absolute',
            top: 'calc(100% + 4px)',
            left: 0,
            right: 0,
            backgroundColor: '#fff',
            border: `1px solid ${primary}`,
            borderRadius: '17px',
            boxShadow: '0 8px 20px rgba(0,0,0,0.2)',
            zIndex: 1000,
            maxHeight: '200px',
            overflowY: 'auto'
          }}>
            {options.map((option) => (
              <div
                key={option.value}
                onClick={() => handleSelect(option.value)}
                style={{
                  padding: '14px 20px',
                  cursor: 'pointer',
                  backgroundColor: option.value === value ? '#fdf2f8' : '#fff',
                  color: option.value === value ? primary : '#374151',
                  borderBottom: '1px solid #e5e7eb',
                  transition: 'background-color 0.2s'
                }}
                onMouseEnter={(e) => option.value !== value && (e.currentTarget.style.backgroundColor = '#fce7f3')}
                onMouseLeave={(e) => option.value !== value && (e.currentTarget.style.backgroundColor = '#fff')}
              >
                {option.label}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};