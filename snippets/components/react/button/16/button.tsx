import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [morphed, setMorphed] = useState(false);
  const primary = theme.primary || '#0891b2';
  return (
  <button className={className} onClick={() => { setMorphed(!morphed); onInteract?.('morph'); }}
  style={{ padding: morphed ? '8px 16px' : '16px 48px', background: primary, color: '#fff',
  border: 'none', borderRadius: morphed ? '50%' : '12px', fontSize: '14px', fontWeight: 700,
  cursor: 'pointer', transition: 'all 500ms cubic-bezier(0.68, -0.55, 0.265, 1.55)', outline: 'none' }}>
  {morphed ? '●' : 'Morph'}
  </button>
  );
};