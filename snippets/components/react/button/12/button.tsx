import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [shake, setShake] = useState(false);
  const primary = theme.primary || '#dc2626';

  const handleClick = () => {
    setShake(true);
    setTimeout(() => setShake(false), 500);
    onInteract?.('shake');
  };

  return (
    <button
      className={className}
      onClick={handleClick}
      style={{
        padding: '14px 32px',
        background: primary,
        color: '#fff',
        border: 'none',
        borderRadius: '10px',
        fontSize: '16px',
        fontWeight: 700,
        cursor: 'pointer',
        animation: shake ? 'shake 500ms' : 'none',
        outline: 'none'
      }}
    >
      Shake Button
      <style>{`
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); }
          20%, 40%, 60%, 80% { transform: translateX(10px); }
        }
      `}</style>
    </button>
  );
};