import React from 'react';;

export interface ComponentProps {
  name?: string;
  badge?: string | number;
  badgeColor?: string;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  name = 'User',
  badge,
  badgeColor = '#ef4444',
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#3b82f6';

  return (
  <div className={className} style={{ position: 'relative', display: 'inline-block' }}>
  <div
  style={{
  width: '56px',
  height: '56px',
  borderRadius: '16px',
  backgroundColor: primary,
  color: '#fff',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '20px',
  fontWeight: '600',
  boxShadow: '0 2px 8px rgba(0,0,0,0.1)'
  }}
  >
  {name.charAt(0).toUpperCase()}
  </div>
  {badge && (
  <div
  style={{
  position: 'absolute',
  top: '-6px',
  right: '-6px',
  minWidth: '24px',
  height: '24px',
  borderRadius: '12px',
  backgroundColor: badgeColor,
  color: '#fff',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '12px',
  fontWeight: '700',
  padding: '0 6px',
  border: '2px solid #fff'
  }}
  >
  {badge}
  </div>
  )}
  </div>
  );
};