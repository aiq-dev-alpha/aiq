import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [value, setValue] = useState('');
  const [focused, setFocused] = useState(false);
  const primary = theme.primary || '#f59e0b';
  const options = ['Apple', 'Banana', 'Cherry', 'Date'];
  const filtered = options.filter(o => o.toLowerCase().includes(value.toLowerCase()));
  return (
    <div className={className} style={{ position: 'relative', width: '240px' }}>
      <input type="text" value={value} onChange={e => { setValue(e.target.value); onInteract?.('input'); }} onFocus={() => setFocused(true)} onBlur={() => setTimeout(() => setFocused(false), 200)} placeholder="Search..." style={{ width: '100%', padding: '12px 16px', border: `2px solid ${focused ? primary : '#e5e7eb'}`, borderRadius: '12px', fontSize: '14px', outline: 'none', transition: 'border-color 200ms' }} />
      {focused && filtered.length > 0 && <div style={{ position: 'absolute', top: '100%', left: 0, right: 0, marginTop: '4px', backgroundColor: '#ffffff', border: '1px solid #e5e7eb', borderRadius: '12px', boxShadow: '0 20px 25px rgba(0,0,0,0.15)', maxHeight: '200px', overflowY: 'auto', zIndex: 10 }}> {filtered.map((option, i) => <div key={i} onClick={() => { setValue(option); onInteract?.('select'); }} style={{ padding: '10px 16px', cursor: 'pointer', fontSize: '14px', borderBottom: i < filtered.length - 1 ? '1px solid #f3f4f6' : 'none' }}> {option} </div> )} </div>}
    </div>
  );
};
