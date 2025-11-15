import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [value, setValue] = useState('');
  const [focused, setFocused] = useState(false);
  const primary = theme.primary || '#22c55e';
  
  return (
    <div className={className} style={{ width: '100%', maxWidth: '360px' }}>
      <input
        value={value}
        onChange={(e) => setValue(e.target.value)}
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        placeholder="Enter text..."
        style={{
          width: '100%',
          padding: '14px 18px',
          border: `2px solid ${focused ? primary : '#e5e7eb'}`,
          borderRadius: '11px',
          fontSize: '16px',
          outline: 'none',
          transition: 'all 250ms',
          background: focused ? `${primary}05` : '#ffffff',
          boxShadow: focused ? `0 0 0 4px ${primary}20` : 'none'
        }}
      />
    </div>
  );
};