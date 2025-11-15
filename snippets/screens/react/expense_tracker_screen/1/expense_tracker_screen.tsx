import React from 'react';
export const Screen: React.FC = () => (
  <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', padding: '2rem', fontFamily: 'system-ui, sans-serif' }}>
    <h1 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '1rem' }}>Screen</h1>
    <div style={{ backgroundColor: '#fff', borderRadius: '0.75rem', padding: '2rem', boxShadow: '0 1px 3px rgba(0,0,0,0.1)' }}>
      <p>Content goes here</p>
    </div>
  </div>
);
