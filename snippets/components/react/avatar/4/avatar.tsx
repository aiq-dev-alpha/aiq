import React from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const primary = theme.primary || '#f59e0b';
  const size = '52px';
  return (
    <div className={className} onClick={() => onInteract?.('click')} style={{ width: size, height: size, borderRadius: '50%', background: `linear-gradient(135deg, ${primary}, ${primary}cc)`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#ffffff', fontSize: '15px', fontWeight: 600, cursor: 'pointer', boxShadow: '0 20px 25px rgba(0,0,0,0.15)', border: '2px solid #ffffff' }}>
      D
    </div>
  );
};
