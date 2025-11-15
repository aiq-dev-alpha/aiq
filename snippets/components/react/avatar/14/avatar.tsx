import React, { useState } from 'react';

export interface ComponentProps {
  name?: string;
  src?: string;
  status?: 'online' | 'offline' | 'away' | 'busy';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  name = 'User',
  src = '',
  status = 'online',
  theme = {},
  className = ''
}) => {
  const primary = theme.primary || '#10b981';
  const statusColors = {
  online: '#10b981',
  offline: '#6b7280',
  away: '#f59e0b',
  busy: '#ef4444'
  };

  return (
  <div className={className} style={{ position: 'relative', display: 'inline-block' }}>
  <div
  style={{
  width: '64px',
  height: '64px',
  borderRadius: '50%',
  backgroundColor: primary,
  color: '#fff',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '24px',
  fontWeight: '600',
  boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
  }}
  >
  {name.charAt(0).toUpperCase()}
  </div>
  <div
  style={{
  position: 'absolute',
  bottom: '2px',
  right: '2px',
  width: '18px',
  height: '18px',
  borderRadius: '50%',
  backgroundColor: statusColors[status],
  border: '3px solid #fff'
  }}
  />
  </div>
  );
};