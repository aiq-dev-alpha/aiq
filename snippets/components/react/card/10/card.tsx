import React from 'react';;

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  return (
  <div
  className={className}
  onClick={() => onInteract?.('click')}
  style={{
  padding: '24px',
  backgroundColor: background,
  color: text,
  border: '1px solid #e5e7eb',
  borderRadius: '8px',
  cursor: 'pointer'
  }}
  >
  <h3 style={{ margin: '0 0 12px 0', fontSize: '18px', fontWeight: 600 }}>Card Title</h3>
  <p style={{ margin: 0, fontSize: '14px', color: '#6b7280' }}>Card content</p>
  </div>
  );
};
