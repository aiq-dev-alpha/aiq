import React from 'react';

export interface InputTheme {
  borderColor: string;
  focusColor: string;
  textColor: string;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  theme?: Partial<InputTheme>;
}

const defaultTheme: InputTheme = {
  borderColor: '#e5e7eb',
  focusColor: '#3b82f6',
  textColor: '#111827'
};

export const Input: React.FC<InputProps> = ({ label, error, theme = {}, style, ...props }) => {
  const appliedTheme = { ...defaultTheme, ...theme };
  return (
    <div>
      {label && <label style={{ fontSize: '0.875rem', fontWeight: 600 }}>{label}</label>}
      <input style={{ padding: '0.75rem', border: `1px solid ${appliedTheme.borderColor}`, borderRadius: '0.5rem', width: '100%', ...style }} {...props} />
      {error && <span style={{ fontSize: '0.75rem', color: '#ef4444' }}>{error}</span>}
    </div>
  );
};
