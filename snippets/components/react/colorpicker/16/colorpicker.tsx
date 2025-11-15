import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [loading, setLoading] = useState(false);
  const primary = theme.primary || '#84cc16';

  const handleClick = () => {
    setLoading(true);
    onInteract?.('loading');
    setTimeout(() => setLoading(false), 2000);
  };

  return (
    <button
      className={className}
      onClick={handleClick}
      disabled={loading}
      style={{
        padding: '16px 36px',
        background: loading ? '#9ca3af' : `linear-gradient(to right, ${primary}, ${primary}cc)`,
        color: '#ffffff',
        border: 'none',
        borderRadius: '8px',
        cursor: loading ? 'not-allowed' : 'pointer',
        fontSize: '15px',
        fontWeight: 600,
        minWidth: '140px',
        position: 'relative',
        overflow: 'hidden',
        transition: 'background 300ms'
      }}
    >
      {loading ? (
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '6px' }}>
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#fff', animation: 'pulse 1.2s infinite' }} />
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#fff', animation: 'pulse 1.2s infinite 0.2s' }} />
          <div style={{ width: '8px', height: '8px', borderRadius: '50%', backgroundColor: '#fff', animation: 'pulse 1.2s infinite 0.4s' }} />
          <style>{'@keyframes pulse { 0%, 100% { opacity: 0.3; } 50% { opacity: 1; } }'}</style>
        </div>
      ) : 'Submit'}
    </button>
  );
};
