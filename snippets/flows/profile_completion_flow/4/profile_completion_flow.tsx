import React, { useState } from 'react';
export const Flow: React.FC = () => {
  const [data, setData] = useState({});
  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f9fafb', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '2rem' }}>
      <div style={{ backgroundColor: '#fff', borderRadius: '1rem', padding: '2.5rem', maxWidth: '500px', width: '100%', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
        <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '1.5rem' }}>Flow</h2>
        <button style={{ padding: '0.875rem 2rem', backgroundColor: '#3b82f6', color: '#fff', border: 'none', borderRadius: '0.5rem', cursor: 'pointer', width: '100%' }}>Submit</button>
      </div>
    </div>
  );
};
