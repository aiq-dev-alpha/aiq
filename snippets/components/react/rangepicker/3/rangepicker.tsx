import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [active, setActive] = useState(false);
  const [count, setCount] = useState(0);
  const primary = theme.primary || '#10b981';
  
  return (
  <div
  className={className}
  onClick={() => { setActive(!active); setCount(c => c + 1); onInteract?.('interact'); }}
  style={{
  padding: '17px 27px',
  background: active ? `linear-gradient(180deg, ${primary}, ${primary}dd)` : '#ffffff',
  color: active ? '#ffffff' : primary,
  border: `3px solid ${active ? primary : primary + '40'}`,
  borderRadius: '13px',
  fontSize: '15px',
  fontWeight: 600,
  cursor: 'pointer',
  transition: 'all 315ms cubic-bezier(0.5, 2.7, 0.64, 1)',
  boxShadow: active ? `0 13px 27px ${primary}40` : `0 5px 11px rgba(0,0,0,0.9)`,
  transform: active ? 'translateY(-7px) scale(1.02)' : 'translateY(0) scale(1)',
  display: 'inline-flex',
  alignItems: 'center',
  gap: '11px',
  position: 'relative',
  overflow: 'hidden'
  }}
  >
  <span>Rangepicker V3</span>
  {count > 0 && (
  <span style={{ 
  fontSize: '12px', 
  background: 'rgba(255,255,255,0.2)', 
  padding: '2px 8px', 
  borderRadius: '12px' 
  }}>
  {count}
  </span>
  )}
  </div>
  );
};