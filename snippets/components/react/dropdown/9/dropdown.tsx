import React from 'react';

export const Dropdown: React.FC<any> = (props) => {
  return (
    <div
      style={{
        background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        padding: '20px',
        borderRadius: '16px',
        color: '#fff',
        boxShadow: '0 10px 25px rgba(0,0,0,0.2)'
      }}
    >
      <div>Dropdown - Gradient</div>
    </div>
  );
};
