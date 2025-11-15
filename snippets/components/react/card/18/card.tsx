import React from 'react';
export const Card: React.FC<{ children: React.ReactNode; elevation?: number; style?: React.CSSProperties }> = ({ children, elevation = 1, style }) => {
  const shadows = ['none', '0 1px 3px rgba(0,0,0,0.1)', '0 4px 6px rgba(0,0,0,0.1)', '0 10px 15px rgba(0,0,0,0.1)'];
  return <div style={{ backgroundColor: '#fff', borderRadius: '0.75rem', padding: '1.5rem', boxShadow: shadows[elevation], ...style }}>{children}</div>;
};
