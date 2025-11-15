import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [visible, setVisible] = useState(true);
  const primary = theme.primary || '#f59e0b';
  if (!visible) return null;
  return (
  <div className={className} style={{ padding: '16px 20px', backgroundColor: `${primary}15`, border: `1px solid ${primary}40`, borderLeft: `4px solid ${primary}`, borderRadius: '12px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '12px' }}>
  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
  <span style={{ fontSize: '20px' }}>ℹ️</span>
  <span style={{ color: primary, fontWeight: 500 }}>Alert message</span>
  </div>
  <button onClick={() => { setVisible(false); onInteract?.('close'); }} style={{ background: 'none', border: 'none', color: primary, fontSize: '18px', cursor: 'pointer', padding: '4px' }}>×</button>
  </div>
  );
};
