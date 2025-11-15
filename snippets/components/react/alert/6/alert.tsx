import React, { useState } from 'react';

interface AlertProps {
  className?: string;
  children: React.ReactNode;
  type?: 'success' | 'error' | 'warning' | 'info';
  dismissible?: boolean;
  bordered?: boolean;
}

export const Alert: React.FC<AlertProps> = ({
  children,
  type = 'info',
  dismissible = true,
  bordered = false
}) => {
  const [isDismissed, setIsDismissed] = useState(false);

  if (isDismissed) return null;

  const colors = {
    success: { bg: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', text: '#fff' },
    error: { bg: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', text: '#fff' },
    warning: { bg: 'linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)', text: '#333' },
    info: { bg: 'linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%)', text: '#333' }
  };

  return (
    <div
      style={{
        background: colors[type].bg,
        color: colors[type].text,
        padding: '14px 18px',
        borderRadius: '12px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        border: bordered ? '2px solid rgba(255,255,255,0.3)' : 'none',
        boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
        backdropFilter: 'blur(10px)'
      }}
    >
      <div style={{ flex: 1, fontSize: '14px', lineHeight: '1.5' }}>{children}</div>
      {dismissible && (
        <button
          onClick={() => setIsDismissed(true)}
          style={{
            background: 'rgba(0,0,0,0.1)',
            border: 'none',
            color: colors[type].text,
            borderRadius: '50%',
            width: '24px',
            height: '24px',
            cursor: 'pointer',
            marginLeft: '12px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '16px',
            transition: 'all 0.2s'
          }}
        >
          ×
        </button>
      )}
    </div>
  );
};

export default Alert;