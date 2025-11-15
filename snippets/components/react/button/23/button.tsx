import React from 'react';
export const Button: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: string }> = ({ children, variant = 'primary', style, ...props }) => {
  const colors = { primary: '#3b82f6', secondary: '#64748b', success: '#10b981' };
  return <button style={{ padding: '0.75rem 1.5rem', borderRadius: '0.5rem', fontWeight: 600, cursor: 'pointer', backgroundColor: colors[variant as keyof typeof colors] || colors.primary, color: '#fff', border: 'none', ...style }} {...props}>{children}</button>;
};
