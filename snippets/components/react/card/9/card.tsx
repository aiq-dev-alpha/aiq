import React from 'react';;

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const primary = theme.primary || '#3b82f6';
  const background = theme.background || '#ffffff';

  return (
  <div
  className={className}
  onClick={() => onInteract?.('click')}
  style={{
  width: '280px',
  backgroundColor: background,
  border: '1px solid #e5e7eb',
  borderRadius: '8px',
  overflow: 'hidden',
  cursor: 'pointer'
  }}
  >
  <div style={{
  height: '160px',
  background: `linear-gradient(135deg, ${primary}, ${primary}dd)`,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  color: '#ffffff',
  fontSize: '48px'
  }}>
  📷
  </div>
  <div style={{ padding: '20px' }}>
  <h3 style={{ margin: '0 0 8px 0', fontSize: '18px', fontWeight: 600 }}>Image Card</h3>
  <p style={{ margin: 0, fontSize: '14px', color: '#6b7280' }}>Card with image header</p>
  </div>
  </div>
  );
};
