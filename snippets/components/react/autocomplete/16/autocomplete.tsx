import React, { useState, useEffect } from 'react';

export interface ComponentProps {
  options?: string[];
  placeholder?: string;
  theme?: { primary?: string; background?: string };
  className?: string;
  onSelect?: (value: string) => void;
}

export const Component: React.FC<ComponentProps> = ({
  options = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'],
  placeholder = 'Type to search...',
  theme = {},
  className = '',
  onSelect
}) => {
  const [value, setValue] = useState('');
  const [filteredOptions, setFilteredOptions] = useState<string[]>([]);
  const [isOpen, setIsOpen] = useState(false);
  const primary = theme.primary || '#10b981';

  useEffect(() => {
    if (value) {
      const filtered = options.filter(opt =>
        opt.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredOptions(filtered);
      setIsOpen(filtered.length > 0);
    } else {
      setFilteredOptions([]);
      setIsOpen(false);
    }
  }, [value, options]);

  const handleSelect = (option: string) => {
    setValue(option);
    setIsOpen(false);
    onSelect?.(option);
  };

  return (
    <div className={className} style={{ position: 'relative', width: '100%', maxWidth: '400px' }}>
      <input
        type="text"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder={placeholder}
        style={{
          width: '100%',
          padding: '10px 16px',
          border: `1px solid ${primary}`,
          borderRadius: '8px',
          fontSize: '14px',
          outline: 'none',
          transition: 'all 0.2s'
        }}
      />
      {isOpen && (
        <div style={{
          position: 'absolute',
          top: '100%',
          left: 0,
          right: 0,
          marginTop: '4px',
          backgroundColor: '#fff',
          border: `1px solid ${primary}`,
          borderRadius: '8px',
          boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
          maxHeight: '200px',
          overflowY: 'auto',
          zIndex: 1000
        }}>
          {filteredOptions.map((option, idx) => (
            <div
              key={idx}
              onClick={() => handleSelect(option)}
              style={{
                padding: '10px 16px',
                cursor: 'pointer',
                borderBottom: idx < filteredOptions.length - 1 ? '1px solid #e5e7eb' : 'none',
                transition: 'background-color 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.backgroundColor = '#ecfdf5'}
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