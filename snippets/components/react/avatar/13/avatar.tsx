import React from 'react';;

export interface ComponentProps {
  avatars?: { src: string; name: string }[];
  maxVisible?: number;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  avatars = [
  { src: '', name: 'User 1' },
  { src: '', name: 'User 2' },
  { src: '', name: 'User 3' },
  { src: '', name: 'User 4' }
  ],
  maxVisible = 3,
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#6366f1';
  const extra = avatars.length - maxVisible;
  const visible = avatars.slice(0, maxVisible);

  return (
  <div className={className} style={{ display: 'flex', alignItems: 'center' }}>
  {visible.map((avatar, i) => (
  <div
  key={i}
  style={{
  width: '48px',
  height: '48px',
  borderRadius: '50%',
  backgroundColor: primary,
  color: '#fff',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '14px',
  fontWeight: '600',
  marginLeft: i > 0 ? '-12px' : '0',
  border: '3px solid #fff',
  position: 'relative',
  zIndex: visible.length - i
  }}
  >
  {avatar.name.charAt(0)}
  </div>
  ))}
  {extra > 0 && (
  <div
  style={{
  width: '48px',
  height: '48px',
  borderRadius: '50%',
  backgroundColor: '#e5e7eb',
  color: '#374151',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '14px',
  fontWeight: '600',
  marginLeft: '-12px',
  border: '3px solid #fff'
  }}
  >
  +{extra}
  </div>
  )}
  </div>
  );
};