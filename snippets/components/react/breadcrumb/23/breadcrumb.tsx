import React from 'react';

export const Breadcrumb: React.FC<any> = (props) => {
  return (
    <div
      style={{
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)',
        border: '1px solid rgba(255, 255, 255, 0.2)',
        borderRadius: '12px',
        padding: '16px',
        boxShadow: '0 8px 32px 0 rgba(31, 38, 135, 0.37)'
      }}
    >
      <div>Breadcrumb - Glassmorphism</div>
    </div>
  );
};
