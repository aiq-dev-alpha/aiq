import React from 'react';
export const Component: React.FC<React.InputHTMLAttributes<HTMLInputElement>> = (props) => (
  <input {...props} style={{ padding: '0.75rem 1rem', borderRadius: '0.5rem', border: '1px solid #d1d5db', width: '100%', ...props.style }} />
);
