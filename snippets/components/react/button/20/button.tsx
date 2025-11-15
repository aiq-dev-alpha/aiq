import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [tilt, setTilt] = useState(0);
  const primary = theme.primary || '#8b5cf6';
  const handleMove = (e: React.MouseEvent) => {
  const rect = e.currentTarget.getBoundingClientRect();
  const x = (e.clientX - rect.left) / rect.width - 0.5;
  const y = (e.clientY - rect.top) / rect.height - 0.5;
  setTilt(x * 20);
  };
  return (
  <button className={className} onClick={() => onInteract?.('tilt')}
  onMouseMove={handleMove} onMouseLeave={() => setTilt(0)}
  style={{ padding: '16px 36px', background: primary, color: '#fff', border: 'none',
  borderRadius: '12px', fontSize: '16px', fontWeight: 700, cursor: 'pointer',
  transform: \`perspective(500px) rotateY(\${tilt}deg)\`, transition: 'transform 100ms',
  transformStyle: 'preserve-3d', outline: 'none' }}>
  Tilt 3D
  </button>
  );
};