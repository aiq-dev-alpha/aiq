import React, { useState } from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const [hovered, setHovered] = useState(false);
  const primary = theme.primary || '#8b5cf6';
  
  return (
  <div
  className={className}
  onMouseEnter={() => setHovered(true)}
  onMouseLeave={() => setHovered(false)}
  onClick={() => onInteract?.('tilt')}
  style={{
  width: '320px',
  padding: '24px',
  background: `linear-gradient(135deg, ${primary}, ${primary}dd)`,
  borderRadius: '20px',
  color: '#fff',
  cursor: 'pointer',
  transform: hovered ? 'perspective(1000px) rotateX(10deg) rotateY(-10deg)' : 'perspective(1000px) rotateX(0) rotateY(0)',
  transition: 'transform 300ms',
  boxShadow: hovered ? `0 25px 50px ${primary}40` : `0 10px 30px ${primary}25`
  }}
  >
  <h3 style={{ margin: '0 0 12px 0', fontSize: '22px' }}>3D Tilt Card</h3>
  <p style={{ margin: 0, opacity: 0.9, fontSize: '15px', lineHeight: 1.5 }}>
  Hover over this card to see the 3D tilt effect in action.
  </p>
  </div>
  );
};