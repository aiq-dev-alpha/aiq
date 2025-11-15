import React from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const primary = theme.primary || '#06b6d4';
  return (
    <span className={className} onClick={() => onInteract?.('click')} style={{ display: 'inline-block', padding: '4px 10px', backgroundColor: primary, color: '#ffffff', borderRadius: '4px', fontSize: '12px', fontWeight: 600, letterSpacing: '0.3px', cursor: 'pointer' }}>
      Badge
    </span>
  );
};
