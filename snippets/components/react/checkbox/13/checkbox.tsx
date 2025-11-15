import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [checked, setChecked] = useState(false);
  const primary = theme.primary || '#10b981';
  return (
  <label className={className} style={{ display: 'inline-flex', alignItems: 'center', gap: '8px', cursor: 'pointer' }}>
  <div onClick={() => { setChecked(!checked); onInteract?.('toggle'); }} style={{ width: '20px', height: '20px', border: `2px solid ${checked ? primary : '#d1d5db'}`, borderRadius: '4px', backgroundColor: checked ? primary : '#ffffff', display: 'flex', alignItems: 'center', justifyContent: 'center', transition: 'all 200ms ease' }}>
  {checked && <span style={{ color: '#ffffff', fontSize: '14px' }}>✓</span>}
  </div>
  <span style={{ fontSize: '14px', userSelect: 'none' }}>Checkbox</span>
  </label>
  );
};
