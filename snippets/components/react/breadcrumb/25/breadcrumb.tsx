import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [loading, setLoading] = useState(false);
  const primary = theme.primary || '#f97316';
  const handleClick = () => { setLoading(true); onInteract?.('loading'); setTimeout(() => setLoading(false), 1500); };
  return (
  <button className={className} onClick={handleClick} disabled={loading} style={{ padding: '12px 32px', backgroundColor: primary, color: '#fff', border: 'none', borderRadius: '20px', cursor: loading ? 'not-allowed' : 'pointer', fontSize: '14px', fontWeight: 600, opacity: loading ? 0.6 : 1, minWidth: '120px', transition: 'opacity 200ms' }}>
  {loading ? 'Loading...' : 'Submit'}
  </button>
  );
};
