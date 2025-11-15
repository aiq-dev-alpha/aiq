import React, { useState } from 'react';

export interface ComponentProps {
  options?: string[];
  placeholder?: string;
  theme?: { primary?: string };
  className?: string;
  onSelect?: (value: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  options = ['Option 1', 'Option 2', 'Option 3'],
  placeholder = 'Select an option',
  theme = {},
  className = '',
  onSelect
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const [selected, setSelected] = useState<string | null>(null);
  const primary = theme.primary || '#14b8a6';
  
  const handleSelect = (option: string) => {
    setSelected(option);
    setIsOpen(false);
    onSelect?.(option);
  };
  
  return (
    <div className={className} style={{ position: 'relative', width: '100%', maxWidth: '300px' }}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        style={{
          width: '100%',
          padding: '18px 26px',
          backgroundColor: '#fff',
          border: `2px solid ${primary}`,
          borderRadius: '11px',
          cursor: 'pointer',
          textAlign: 'left',
          fontSize: '11px',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}
      >
        <span style={{ color: selected ? '#111' : '#9ca3af' }}>
          {selected || placeholder}
        </span>
        <span style={{ transform: isOpen ? 'rotate(180deg)' : 'rotate(0)', transition: 'transform 0.2s' }}>
          ▿
        </span>
      </button>
      {isOpen && (
        <div style={{
          position: 'absolute',
          top: '100%',
          left: 0,
          right: 0,
          marginTop: '4px',
          backgroundColor: '#fff',
          border: `1px solid ${primary}`,
          borderRadius: '11px',
          boxShadow: '0 1px 2px rgba(0,0,0,0.05)',
          zIndex: 1000
        }}>
          {options.map((option, idx) => (
            <div
              key={idx}
              onClick={() => handleSelect(option)}
              style={{
                padding: '18px 26px',
                cursor: 'pointer',
                borderBottom: idx < options.length - 1 ? '1px solid #e5e7eb' : 'none',
                transition: 'background-color 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#f0fdfa'}
              onMouseLeave={(e) => e.currentTarget.style.backgroundColor = '#fff'}
            >
              {option}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};